\documentclass[a4paper]{article}
\pagestyle{myheadings}
\usepackage{haskell}
\begin{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\section{Generating Pairs}

From a list of $k$-cliques, generate the suffix pairs that are
left-maximal, and thus represents endpoints in one direction or other.

Construct maximal matches from these endpoints, and collect them
as consistent sets, which then can be scored.

The data structure {\tt SPair} represents the pair generated by a
single suffix match, while {\tt MPair} is the result of collapsing
the {\tt SPair}s referencing the same ESTs.
\begin{code}
{-# LANGUAGE FunctionalDependencies, MultiParamTypeClasses, PatternSignatures #-}
{-# OPTIONS -fno-warn-incomplete-patterns #-}

module Pairs(Match(..),SMPair(..),Pair(..),
             pairs,matches,sort_pure,sort_io,mpairs,elim_bs,
             psort,collect,blocks,showmatch,direction,
             prefixes,merge_suffix_lists,show_header,show_regs)
where
import EST(EST(..),mkshowlist,label,index)
import Gene
import Suffix(Suffix(..),Dir(..),cmp)
import Indexed
import System.Cmd (system)
import System.Directory(doesFileExist,renameFile)
import System.Posix.Files(getFileStatus,fileSize)
import Data.List(sort,sortBy,partition,groupBy)
import Data.Map hiding (map,insert,(!),filter,null,partition,adjust,foldl')
import System.IO(hPutStrLn,stderr,openFile,IOMode(ReadMode),hIsEOF)
import Control.Monad(mapM,when)
import System.IO.Unsafe(unsafePerformIO,unsafeInterleaveIO)
import Util(foldl',sortOn)
import ANSI
import Data.Char(ord,chr)

-- import Data.Array.IArray hiding (index)
import Data.Array.IO hiding (index)
import Data.Array.Unboxed hiding (index)
import Data.Word

-- single match pair, multiple match pair, scored multiple match pair
data Match  = Match !Suffix !Suffix
data MPair  = MPair !EST !EST ![Block]
data SMPair = SMPair !Dir !EST !EST !Int [Block]
type Clique = [Suffix]

-- this class should eliminate much of the need to look inside pairs
class Pair a n | a -> n where
    score :: a -> Int                -- the score of a pair
    ests  :: a -> (n,n) -- the ESTs referenced

instance Pair Match EST where
    score (Match _ _) = error ("matches don't have a score")
    ests (Match (Suf _ e0 _) (Suf _ e1 _)) = (e0,e1)

instance Show Match where
    show (Match (Suf d0 e0 off0) (Suf d1 e1 off1)) =
        "# Match "++ dir d0 ++ label e0 ++"["++show off0++"] "
        ++ dir d1 ++ label e1 ++"["++show off1++"]"
        where
        dir x = if x==Rev then "R" else ""

instance Pair MPair EST where
    score _ = error "mpairs don't have a score"
    ests (MPair e0 e1 _) = (e0,e1)

instance Show MPair where
    show (MPair e0 e1 ps) = if length ps /= 0
         then "MPair "++label e0++","++label e1++":"++show ps else "#empty"

instance Pair SMPair EST where
    score (SMPair _ _ _ s _)  = s
    ests (SMPair _ e0 e1 _ _) = (e0,e1)

instance Show SMPair where
    show (SMPair d e0 e1 s ps) =
        "# SMPair "++ show d ++ " " ++ label e0 ++" "++show (p0s ps)++" "
        ++ label e1 ++" "++ show (p1s ps) ++ " score:"++show s
        ++"\n"
        ++ showbs 0 (p0s ps) e0 ++ "\n"
        ++ showbs 0 (p1s (if d==Rev then reverse ps else ps)) e1 ++ "\n"
        where
        p0s [] = []
        p0s (B x _ l:xs) = (x,x+l-1):p0s xs
        p1s [] = []
        p1s (B _ y l:xs) = (y,y+l-1):p1s xs
        showbs c ((i0,i1):is) e = mkshowlist (c,i0-1) e
                                  ++ ANSI.attrReverse ++ mkshowlist (i0,i1) e
                                  ++ ANSI.attrClear ++ showbs (i1+1) is e
        showbs i [] e = mkshowlist (i,len e) e

show_header :: SMPair -> String
show_header (SMPair d e0 e1 s ps) =
        "# SMPair "++ show d ++ " " ++ label e0 ++" "++show (p0s ps)++" "
        ++ label e1 ++" "++ show (p1s ps) ++ " score:"++show s
        where
        p0s [] = []
        p0s (B x _ l:xs) = (x,x+l-1):p0s xs
        p1s [] = []
        p1s (B _ y l:xs) = (y,y+l-1):p1s xs

-- TODO: write to temp files and sort them?
show_regs :: SMPair -> String
show_regs (SMPair _ e0 e1 _ ps) =
        label e0 ++" "++show (p0s ps)++"\n"
        ++ label e1 ++" "++ show (p1s ps)
        where
        p0s [] = []
        p0s (B x _ l:xs) = (x,x+l-1):p0s xs
        p1s [] = []
        p1s (B _ y l:xs) = (y,y+l-1):p1s xs

direction :: SMPair -> Bool
direction (SMPair Fwd _ _ _ _) = True
direction (SMPair Rev _ _ _ _) = False

-- | Construct scored pairs from {\tt Match}es.
pairs :: Bool -> [Match] -> [SMPair]
pairs nolcr = map calc_score . mpairs nolcr

-- �seq� a list
-- strict :: (Eq a) => [a] -> [a]
-- strict xs = if xs == [] then [] else
--             if last xs == last xs then xs else error "unstrict"

--  intermediate steps, exported for debugging/test cases
mpairs :: Bool -> [Match] -> [(Maybe MPair, Maybe MPair)]
mpairs nolcr = map blocks . collect nolcr

\end{code}

\newpage
\subsection{Sorting {\tt Match}es}

Matches can either be sorted in memory, or written to a file and
sorted by an external program (typically Unix's sort(1))."

\begin{code}

-- internal sorting matches
sort_pure :: [Match] -> [Match]
sort_pure = sortBy c
    where
    (Match s0 s1) `c` (Match t0 t1) = case cmp s0 t0 of
           GT -> GT
           LT -> LT
           EQ -> cmp s1 t1

-- external sorting matches
sort_io :: [EST] -> String -> [Match] -> IO [Match]
sort_io es fn ms = do
                let outfile = fn++"_M"
                let infile = fn++"_MS"
                let outtmp = outfile++".tmp"
                let intmp = infile++".tmp"
                ot <- doesFileExist outtmp
                it <- doesFileExist intmp
                o <- doesFileExist outfile
                i <- doesFileExist infile
                when (ot || it) $
                   fail ("Temporary files exist -- xsact already running?\n"
                         ++if ot then outtmp else intmp)
                when (not o && not i) $ do
                        hPutStrLn stderr
                            "Building the suffix list from scratch"
                        build_suffix_list outtmp outfile ms
                when (not i) $ do
                        when o $ hPutStrLn stderr
                                 "Recycling the unsorted suffix list from file"
                        sort_suffix_list outfile intmp infile
                when i $ hPutStrLn stderr "Recycling the sorted suffix list from file"
                read_suffix_list infile es

build_suffix_list :: String -> String -> [Match] -> IO ()
build_suffix_list outtmp outfile ms = do
    writeFile outtmp (unlines $ map showmatch ms)
    renameFile (outfile++".tmp") outfile
    return ()

sort_suffix_list :: String -> String -> String -> IO ()
sort_suffix_list outfile intmp infile = do
    system("LC_ALL=C TMPDIR=. sort "++outfile++" > "++intmp)
    new <- getFileStatus intmp
    old <- getFileStatus outfile
    -- handle case where sorting fails, e.g. due to out of TMP space
    if fileSize new /= fileSize old then
         fail ("Error: Sizes differ in tmp files!"
               ++outfile ++ " : " ++ show (fileSize old) ++ "\n"
               ++intmp ++ " : " ++ show (fileSize new))
       else do
         renameFile (infile++".tmp") infile
         return ()

-- read the -x file as a lazy list of arrays
readXFile :: FilePath -> IO [UArray Int Word8]
readXFile f = do
              h <- openFile f ReadMode
              getArrays h
    where getArrays h = do end <- hIsEOF h
                           case end of
                             True -> return []
                             False -> do
                                (a :: IOUArray Int Word8) <- newArray (0,17) 0
                                hGetArray h a 18
                                a' <- unsafeFreeze a
                                as <- unsafeInterleaveIO (getArrays h)
                                return (a':as)


emap :: [EST] -> Map Int EST
emap ests = fromList $ zip (map index ests) ests

read_suffix_list :: String -> [EST] -> IO [Match]
read_suffix_list infile es = do
    stat <- getFileStatus infile
    when (fileSize stat == 0)
         (hPutStrLn stderr ("Warning: temporary file "++infile++" is empty!"))
    res <- readXFile infile
    return (reconstruct (emap es) res)

merge_suffix_lists :: [EST] -> Int -> String -> IO [Match]
merge_suffix_lists es depth fn = do
    let fs = map ((++"_MS").(fn++).concatMap show) (prefixes depth)
    ress <- mapM readXFile fs
    let res = merge ress
    return (reconstruct (emap es) res)

-- | calculate prefixes (also used in Xsact)
prefixes :: Int -> [[Gene]]
prefixes p = prefixes' p [[]]

prefixes' :: Int -> [[Gene]] -> [[Gene]]
prefixes' p sufs
    | p == 0 = sufs
    | p > 0  = prefixes' (p-1) $ concat [map (A:) sufs,
               map (C:) sufs, map (G:) sufs, map (T:) sufs]
    | otherwise = error "must have positive prefix length!"

-- use linear time insertion (could use an FM to get log time)
merge :: Ord a => [[a]] -> [a]
merge xs = merge'
           $ sortBy (\a b->compare (head a) (head b)) $ filter (not.null) xs

merge' :: (Ord a) => [[a]] -> [a]
merge' (x':xx) = head x' : merge' (insert (tail x') xx)
    where insert a@(_:_) (b:bs) = if head a < head b then (a:b:bs)
                            else b : insert a bs
          insert [] xs    = xs
          insert a []     = [a]
merge' [] = []

-- fancy encoding of integers
alpha :: String
alpha = ['0'..'z']

i2a :: Int -> Int -> String
i2a n i = reverse $ take n $ (i2a' i ++ (repeat $ head alpha))
    where
    i2a' i = if i < length alpha then [chr $ ord (head alpha) + i]
             else let (q,r) = i `divMod` (length alpha)
                  in (chr $ ord (head alpha) + r) : i2a' q

a2i :: String -> Int
a2i = a2i' 0
    where
    a2i' acc "" = acc
    a2i' acc (s:ss) = acc `seq`
        a2i' (length alpha * acc + (ord s - ord (head alpha))) ss

-- WARNING: arbitrary constants alert!
-- Limited to 2.5M sequences, max length 240Kbase
showmatch :: Match -> String
showmatch m@(Match s1 s2) = unwords [is, p s1 ++ p s2, [alpha !! (2*d s1 +d s2)]]
    where
    (e1,e2) = ests m
    is = i2a 4 (index e1) ++ i2a 4 (index e2)
    p (Suf _ _ pos) = i2a 3 pos
    -- fix these as well
    d (Suf Rev _ _) = 0
    d (Suf Fwd _ _) = 1

reconstruct :: Map Int EST -> [UArray Int Word8] -> [Match]
reconstruct emap (arr:arrs) = Match (Suf d1 s1 p1) (Suf d2 s2 p2)
                              : reconstruct emap arrs
    where
    s1 = elookup (get [0..3])
    s2 = elookup (get [4..7])
    p1 = get [9..11]
    p2 = get [12..14]
    (d1,d2) = let (x,y) = divMod (get [16]) 2 in (d x, d y)
    d w = case w of { 1 -> Fwd; 0 -> Rev; _ -> error ("arr is "++show arr)}
    get = a2i . map (chr . fromIntegral . (arr!))
    elookup i = case Data.Map.lookup i emap of
         Just e -> e
         Nothing -> error ("The impossible happened: sequence "
                    ++show i++" not found")
reconstruct _ [] = []

\end{code}

\newpage
\subsection{Generating the pairs from a clique}

We generate all pairs between the first suffix and the rest of
the suffixes which differ in the first nucleotide. I.e., pairs are
constructed from maximal matches starting in this clique.

Since the clique is only sorted to block size (k), we can reorder it
arbitrarily.  In order to generate maximal pairs efficiently, we take
advantage of this, and order suffixes by preceeding nucleotide.

\begin{code}

matches :: [[Suffix]] -> [Match]
matches = concat . map ({- strict . -} maxMatches)

-- generate all maximal starting points for matching blocks
maxMatches :: Clique -> [Match]
maxMatches = map order_match . gen_pairs . order_clique

-- split a clique according to preceeding nucleotide
-- todo: optimize to do a single pass over the data
order_clique :: Clique -> [[Suffix]]
order_clique ss = [[s | s <- ss, pred s]
            | pred <- [mismatch, prec A, prec C, prec G, prec T]]
           where
           start (Suf Fwd _ p) = p==0
           start (Suf Rev e p) = p==len e
           -- silly workaround, N doesn't match anything, including N:
           mismatch s = start s || not (s ?? (-1) `elem` [A,C,G,T])
           prec nuc s = if start s then False else s ?? (-1) == nuc

-- generate all internal pairs from the first subclique (i.e. starting/Ns)
gen_pairs :: [[Suffix]] -> [Match]
gen_pairs (ss:sss) = internal ss ++ gen_pairs2 (ss:sss)
    where
    internal [] = []
    internal (s:ss) = map (Match s) ss ++ internal ss

-- generate all pairs from the first part against the rest
gen_pairs2 :: [[Suffix]] -> [Match]
gen_pairs2 (_ss:[]) = []
gen_pairs2 (ss:sss) = [Match s1 s2 | s1 <- ss, s2 <- concat sss]
                     ++ gen_pairs2 sss

-- ensure that matches are ordered internally, least sequence first
order_match :: Match -> Match
order_match (Match s1 s2) = if cmp s1 s2 == GT
                            then Match s2 s1 else Match s1 s2

\end{code}

\newpage
\subsection{Collecting Matches and Identifying Blocks}

The generated pairs are sorted (by EST reference) and pairs
referencing the same ESTs but at different locations are collected.

The blocks are then identified by looking at matches in opposite
directions on the same diagonal.

\begin{code}

-- collect matches that refer to the same ests
collect :: Bool -> [Match] -> [([Match],[Match])]
collect _ [] = []
collect nolcr ms@(_:_) =
    let (e0,_) = ests $ head ms
        (this,rest) = break (\x -> (fst $ ests x) /= e0) ms
    in collect' nolcr this ++ collect nolcr rest

collect' :: Bool -> [Match] -> [([Match], [Match])]
collect' _ [] = []
collect' nolcr ms@(_:_) =
    let es@(e0,e1)  = (ests . head) ms
        (this,rest) = break (\x -> ests x /= es) ms
    in
    -- filter out and warn about matches internal to a sequence
    if e0==e1 then if not nolcr then let rs = remove_overlap $ regions this
                                 in warn e0 rs `seq`
                                    collect' nolcr (maskRegions rs rest)
                   else collect' nolcr rest
    else divide this : collect' nolcr rest

-- regions may overlap, this causes out of order matches
remove_overlap :: [(Int,Int)] -> [(Int,Int)]
remove_overlap ((r0,r1):(s0,s1):rs) =
    if r1>=(s0-1) then remove_overlap ((r0,s1):rs)
       else (r0,r1) : remove_overlap ((s0,s1):rs)
remove_overlap [rs] = [rs]
remove_overlap []   = []

warn :: EST -> [(Int, Int)] -> ()
warn _ [] = ()
warn e rs = unsafePerformIO $ hPutStrLn stderr
            ("Low Complexity Regions in "++ label e
             ++ " ignored:\n" ++ (unlines $ map show' rs))
    where
    show' (a,b) = show (a,b) ++ ": " ++ concatMap (show . (e ?? )) [a..b]

-- given all self-matches in a sequence,
-- determine regions, by looking for sequences of locations for a
-- match for forward matches, the first location is constant, for
-- reverse, the second is constant
regions :: [Match] -> [(Int,Int)]
regions ms = zip regions_f (reverse regions_r) -- region' $ sort $ map order_pair psf)
    where
    psf = [order_pair (p1,p2) | (Match (Suf Fwd _ p1) (Suf Fwd _ p2)) <- ms]
    psr = [unorder_pair (p1,p2) | (Match (Suf Rev _ p1) (Suf Rev _ p2)) <- ms]
    regions_f = regions' $ sort psf
    regions_r = regions' $ reverse $ sort psr
    regions' [] = []
    regions' ((a,b):pp)
        | abs (a-b) > 4 = regions' pp
        | otherwise         =
            let rest = dropWhile (\(x,y)->x==a || y==b) pp
                in a : regions' rest
    order_pair (x,y) = if x <= y then (x,y) else (y,x)
    unorder_pair (x,y) = if x >= y then (x,y) else (y,x)

-- find matches in regions, and remove them
-- observe: a match extending beyond the LCR must exit through the "corner".
-- NB: regions may overlap
maskRegions :: [(Int,Int)] -> [Match] -> [Match]
maskRegions [] ms = ms
maskRegions rs ms =
    concatMap (mask1 rs) $ groupBy (\x y -> ests x == ests y) ms

mask1 :: [(Int, Int)] -> [Match] -> [Match]
mask1 ((r0,r1):rs) ms =
    let (first,ms') = partition (\m -> p1 m < r0) ms
        (region,rest) = partition (\m -> p1 m <= r1) ms'
        singletons = concat $ filter (\x -> length x == 1) $ matchpairs $ diags region
    in
    first ++ map (adjust (r0,r1)) singletons ++ maskRegions rs rest
    -- error $ unlines $ concat $ [map show first,["-1"], map show $ diags region,["-2"],map show rest,["-3"],map show singletons]

adjust :: (Int, Int) -> Match -> Match
adjust (r0,r1) m = case (d1 m,d2 m) of
                   (Fwd,Fwd) -> movediag (max 0 (r1 - p1 m - 3)) m
                   (Rev,Rev) -> movediag (min 0 (r0 - p1 m + 3)) m
                   (Fwd,Rev) -> movediag' (max 0 (r1 - p1 m - 3)) m
                   (Rev,Fwd) -> movediag' (min 0 (r0 - p1 m + 3)) m

matchpairs :: [[Match]] -> [[Match]]
matchpairs []     = []
matchpairs (d:ds) = mps $ map (sortOn p1) (d:ds)

mps :: [[Match]] -> [[Match]]
mps (d:ds) = if length d > 2 then
                       if (d1 $ head d) == Fwd
                          then take 2 d : matchpairs (drop 2 d:ds)
                          else [head d] : matchpairs (tail d:ds)
                    else d : matchpairs ds

-- Match accessor functions
p1 :: Match -> Int
p1 (Match (Suf _ _ p) _) = p
-- p2 (Match _ (Suf _ _ p)) = p

d1, d2 :: Match -> Dir
d1 (Match (Suf d _ _) _) = d
d2 (Match _ (Suf d _ _)) = d

movediag, movediag' :: Int -> Match -> Match
movediag n (Match (Suf d1 e1 p1) (Suf d2 e2 p2)) =
    (Match (Suf d1 e1 (p1+n)) (Suf d2 e2 (p2+n)))
movediag' n (Match (Suf d1 e1 p1) (Suf d2 e2 p2)) =
    (Match (Suf d1 e1 (p1+n)) (Suf d2 e2 (p2-n)))

-- divide the matches into co- and contradirectional
divide :: [Match] -> ([Match],[Match])
divide ms = let
    coDir (Match (Suf d1 _ _) (Suf d2 _ _)) = d1==d2
    in partition coDir ms

-- blocks identified from co- and contradirectional matches
blocks :: ([Match],[Match]) -> (Maybe MPair,Maybe MPair)
blocks (x,y) = (blocks' x, blocks' y)

blocks' :: [Match] -> Maybe MPair
blocks' [] = Nothing
blocks' bs = let
    -- order by diagonal
    (e0,e1) = ests (head bs)
    ds = diags bs
    poscmp (Match (Suf _ _ p1) _) (Match (Suf _ _ p2) _) = compare p1 p2
    sds = map (sortBy poscmp) ds
    -- we'll always have interleaved directions on a diagonal, won't we?
    bls [] = []
    -- the co-directional case
    bls ((Match (Suf Fwd _e p1) (Suf Fwd _e' p1'))
         :(Match (Suf Rev _ p2) (Suf Rev _ _p2')):rest)
        = (B p1 p1' (p2-p1+1)):(bls rest)
    -- the contra-directional case
    bls ((Match (Suf Fwd _e p1) (Suf Rev _e' _p1'))
         :(Match (Suf Rev _ p2) (Suf Fwd _ p2')):rest)
        = (B p1 p2' (p2-p1+1)): (bls rest)
    bls _ = error ("blocks not in correct order: impossible!\n"
                   ++ unlines (map show sds) ++ "\n" ++ show bs)
    in
    Just (MPair e0 e1 (concatMap bls sds))

-- partition matches by diagonal
diags :: [Match] -> [[Match]]
diags []     = []
diags (b:bs) = let
               (d,rest) = partition (\x-> diag x==diag b) bs
               in
               (b:d) : diags rest

diag :: Match -> Int
diag (Match (Suf d _ p1) (Suf d' _ p2)) = if d==d' then p1-p2 else p1+p2

\end{code}

\newpage
\subsection{Calculating SMPair Scores}

Basically, the score is calculated as the sum of lengths of maximal
matches.  There are some complications, however.

\begin{itemize}
\item a block from one sequence can match another in
multiple places (typically when blocks are repeated in a sequence),
which artificially inflates the sum of scores.
\item Additionally blocks may match in a disordered fashion, which is
unlikely to result from RNA behaviour.
\item Blocks may overlap, which also inflates the score
\end{itemize}

We therefore need to inspect each {\tt MPair} to adjust for these
eventualities.

\subsection{Data Structures for Block}

A Block is a matching block with start positions in each sequence and
lenght.  An EndPoint is a point in both sequences along with the total
score (sum of lengths) in the Blocks leading to it.

The list of Blocks is sorted according to least starting position,
while the list of EndPoints is kept sorted by score to improve
efficiency (essentially linear in the number of blocks - I think).

\begin{code}

data Block = B !Int !Int !Int deriving Show -- x y lenght
data EndPoint = EP Int [Block] -- total score and list of blocks

-- blocks can be costly to keep, thus we may want to eliminate them
elim_bs :: SMPair -> SMPair
elim_bs (SMPair d e0 e1 s _) = d `seq` e0 `seq` e1 `seq` s `seq`
    (SMPair d e0 e1 s (error "Blocks were eliminated from this SMPair!"))

\end{code}

The function {\tt calc\_score}
finds in an {\tt MPair} the set of non-overlapping matches
sequential in both sequences, AKA the consisten set of maximal
matches. It then uses the resulting score to create an {\tt SMPair}.

The implementation is a variant of the standard dynamic programming
algorithm,
incrementally creating list of endpoints with optimal scores.  The
optimal score for a matching block is calculated by looking at all
matching blocks whose starting point is earlier in both sequences, and
{\tt filter}ing out only those whose end point is earlier than the
starting point of our current block (ie. that are eligible for
alignment).  From the remaining blocks, the highest scoring one is
selected, and the new end point is added along with the current
block's length plus this score.

\begin{code}

calc_score :: (Maybe MPair, Maybe MPair) -> SMPair
calc_score (Nothing, Nothing) = error "too much of Nothing"
calc_score (Nothing, Just (MPair e0 e1 conps)) =
    srev (calc_score' (MPair e0 e1 (map rev conps)))
        where
        rev (B p0 p1 l) = B p0 (-p1-l) l
        srev (SMPair _ e0 e1 s bs) = SMPair Rev e0 e1 s (map rev bs)
calc_score (Just co, Nothing) = calc_score' co
calc_score (Just co, Just (MPair e0 e1 conps)) =
    select1 (calc_score' co,
             srev (calc_score' (MPair e0 e1 (map rev conps))))
        where
        rev (B p0 p1 l) = B p0 (-p1-l) l
        srev (SMPair _ e0 e1 s bs) = SMPair Rev e0 e1 s (map rev bs)

select1 :: (SMPair,SMPair) -> SMPair
select1 (p0@(SMPair _ _ _ s0 _), p1@(SMPair _ _ _ s1 _)) =
    if s0>s1 then p0 else p1

calc_score' :: MPair -> SMPair
calc_score' (MPair _ _ []) = error "SMPair undefined undefined undefined 0 []"
calc_score' m@(MPair ex ey _) =
    let EP sc bs = calc_score'' m
        bs' = reverse bs
        in SMPair Fwd ex ey sc bs'

calc_score'' :: MPair -> EndPoint
calc_score'' (MPair _ _ ps) =
    head $ foldl' insert [] (sortBy c ps) -- aren't they already sorted?

insert :: [EndPoint] -> Block -> [EndPoint]
insert [] b@(B _ _ l)  = [EP l [b]]
-- inserting stops when it finds the first compatible end-point which
-- is non-overlapping
insert (ep:eps) b@(B _ _ l) =
    let ep' = ins1 b ep
        score (EP sc _bs) = sc
        in if compat b ep && (not . null) ep'
           then if (score . head) ep' == score ep + l
                then ep' ++ (ep:eps)                 -- no overlap: terminate
                else ep' ++ bubble ep (insert eps b) -- continue searching
           else bubble ep (insert eps b)             -- not compat, keep going

compat :: Block -> EndPoint -> Bool
compat (B x y _l) (EP _sc (B x' y' _l' : _bs)) = x'<x && y'<y

ins1 :: Block -> EndPoint -> [EndPoint]
ins1   (B x y l) (EP sc (B x' y' l' : bs)) =
        -- ins must take into account partial overlap, 'd'
        let d = maximum [(x'+l'-x),(y'+l'-y),0]
            in if d<l then [EP (sc+l-d) (B (x+d) (y+d) (l-d):B x' y' l':bs)]
               else []

bubble :: EndPoint -> [EndPoint] -> [EndPoint]
bubble (EP sc bs) (EP sc' bs':eps)
           | sc<sc'    = (EP sc' bs':EP sc bs:eps)
           | otherwise = (EP sc bs:EP sc' bs':eps)

c :: Block -> Block -> Ordering
(B x y _l) `c` (B x' y' _l') = compare  (max x y) (max x' y')

\end{code}

\subsection{Sorting Pairs by Score}

The {\tt sortBy'} function implements sorting with equality
collection.  This is {\em really} useful when you expect lots of
similar values.  (Is this "ternary quicksort"?)

\begin{code}

-- | sort pairs by score
psort :: [SMPair] -> [SMPair]
psort = sortBy' pc
    where
    (SMPair _ _ _ s _) `pc` (SMPair _ _ _ s' _) = compare s' s

-- sorting with equality collection
sortBy' :: (a -> a -> Ordering) -> [a] -> [a]
sortBy' _  [] = []
sortBy' pc xs = let (l,e,g) = part3 (`pc` head xs) xs
                              in sortBy' pc l ++ e ++ sortBy' pc g
    where
    part3  comp xs = p3 [] [] [] comp xs
    p3 ls es gs _ [] = (ls,es,gs)
    p3 ls es gs comp (x:xs) = case comp x of
                                          LT -> p3 (x:ls) es gs comp xs
                                          EQ -> p3 ls (x:es) gs comp xs
                                          GT -> p3 ls es (x:gs) comp xs

\end{code}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\end{document}