module Render where
import Instruction
import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Export.Image
import Graphics.Gloss.Export.PNG
import Graphics.Gloss.Interface.Environment
import RenderSVG
import DisplayMode

-- Render.hs: The renderer, which takes a list of Instructions and produces
-- a Gloss picture.

-- Render state: you will want to change this to keep track of the different
-- properties you need to record while you render the picture (e.g., the current
-- colour, co-ordinates, and whether the pen is up or down)
data RenderState =     
    RenderState
    { x :: Float, y :: Float, angle :: Int, penDown :: Bool, currentColor :: Color}
    deriving (Eq, Show)

{- Exercise 5 -}
-- Convert degrees to radians
degreesToRadians :: Float -> Float
degreesToRadians degrees = degrees * (pi/180)


newCoords :: (Float, Float) -> Int -> Int -> (Float, Float)
newCoords (x, y) dist angle = (x1,y1)
    where
        -- degrees to radians conversion
        radians = degreesToRadians(fromIntegral angle)
        -- assign each new coordinate
        x1 = x + fromIntegral dist * cos radians
        y1 = y + fromIntegral dist * sin radians

{- Exercise 6 -}

-- Implement a function renderInstruction which takes a render state and an
-- instruction, and produces a new state
renderInstruction :: RenderState -> Instruction -> RenderState
renderInstruction rState (IMove dist) = 
    -- produce new coordinates
    let (x1,y1) = newCoords (x rState, y rState) dist (angle rState)
    in
    -- update new coords
    rState {x = x1, y = y1}
renderInstruction rState (IRotate deg) = 
    -- update angle
    rState {angle = (fromIntegral(deg + angle rState)) `mod` 360}
renderInstruction rState IPenUp = 
    -- update with pen up
    rState {penDown = False}
renderInstruction rState IPenDown = 
    -- update with pen down
    rState {penDown = True}
renderInstruction rState (IChangeColor c) = 
    -- update with color
    rState {currentColor = c}

-- Implement the renderPicture function which renders a list of instructions
-- using renderInstruction.
-- The first argument is the turtle picture; you can then use 'formatTurtle' to
-- place the turtle given the final angle and co-ordinates.
renderPicture :: Picture -> [Instruction] -> Picture
renderPicture turtlePic instrs =
    let
        -- initial state of the turtle
        initState = RenderState 0 0 0 True white
        -- iterate list of instructions
        (RenderState x y angle penDown color) = foldl renderInstruction initState instrs
        turtlePic' = formatTurtle (fromIntegral angle) x y turtlePic
        drawnPath = if penDown then [Line [(0, 0), (x, y)], turtlePic'] else [turtlePic']
    in
     -- combine the list of pictures
    Pictures drawnPath

{- ------------- -}

{- The remainder of the file consists of helper functions, which you should
 - not need to modify. -}

{- Translate and rotate turtle picture. Takes the final angle and co-ordinates
 - of the turtle after rendering all instructions. -}
formatTurtle :: Float -> Float -> Float -> Picture -> Picture
formatTurtle angle x y =
    let rotateTurtle = Graphics.Gloss.rotate angle in
    let translateTurtle = Graphics.Gloss.translate x y in
    (translateTurtle . rotateTurtle)

loadTurtlePic :: IO Picture
loadTurtlePic = do
    turtle <- loadJuicyPNG "turtle.png"
    case turtle of
        Just pic -> return pic
        Nothing -> ioError $ userError "Could not load turtle.png"

size :: Size
size = (900, 900)

-- Exports a picture to a PNG
export :: FilePath -> Picture -> IO ()
export path pic = do
    -- First translate the picture so it is in the centre of the exported
    -- viewport
    (w, h) <- getScreenSize
    let pic' = translate (fromIntegral $ -(div w 4)) (fromIntegral $ div h 4) pic
    exportPictureToPNG (w, h) white path pic'

-- Shows a picture
displayPic :: Picture -> IO ()
displayPic pic = do
    let window = InWindow "Turtle Graphics Assignment" size (0, 0)
    display window white pic

-- Main entry point: takes a list of instructions and a display mode, and
-- runs the rendering logic.
render :: [Instruction] -> DisplayMode -> IO ()
render instrs mode = do
    turtlePic <- loadTurtlePic
    let pic = renderPicture turtlePic instrs
    case mode of
        GlossWindow -> displayPic pic
        GlossExport path -> export path pic
        SVGExport path -> exportSVG size path pic
