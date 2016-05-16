module Main exposing (main)

-- Given a specification for a Josef Albers-style "Homage to the Square"
-- painting, calculate the dimensions of each constituent square, and
-- produce a representation of the resulting painting.

import Color as Color exposing (Color)
import Element exposing (Element, Position)
import Html exposing (Html)
import Html.App as App
import List.Extra as List

type alias Inches = Float

inchesToPixels : Inches -> Int
inchesToPixels = round << ((*) 100)

type alias Dimensions =
    { width : Inches
    , height : Inches
    }

-- The specification for an "Homage to the Square"-style painting.
-- This specification, combined with constraints on the dimensions of
-- borders, etc., is sufficient to generate a painting.
type alias Painting =
    { frame : Square -- The outermost shape. Need not be a true square.
    -- The width of the frame can be different from the intermediate borders.
    , frameWidth : Inches
    , nucleus : Square -- The innermost square
    -- A real number between 1 and -1. Controls the vertical padding between intermediate squares.
    -- A perspective of -1 will cause all intermediate squares to share the same base.
    -- A perspective of 1 will cause all intermediate squares to share the same top.
    -- A perspective of 0 will cause all intermediate squares to be perfectly concentric.
    , verticalPerspective : Float
    -- The colors of the intermediate squares, listed from the outside in.
    , intermediates : List Color 
    }

-- A constituent square within an "Homage to the Square"-style painting.
type alias Square =
    { dimensions : Dimensions
    , color : Color
    }

view : Painting -> Html {}
view painting = 
    let p : Inches
        p = intermediatePadding painting

        framePosition : Inches -> Position
        framePosition _ = Element.midBottomAt (Element.absolute <| inchesToPixels (painting.frame.dimensions.width / 2))
            <| Element.absolute
            <| inchesToPixels painting.frameWidth

        intermediatePosition : Inches -> Position
        intermediatePosition width = Element.midBottomAt (Element.absolute <| inchesToPixels width) 
            <| Element.absolute
            <| inchesToPixels p
    in Element.toHtml
        <| nestSquare framePosition painting.frame
        <| List.foldr (nestSquare intermediatePosition) (viewSquare painting.nucleus)
        <| intermediateSquares painting

nestSquare : (Inches -> Position) -> Square -> Element -> Element
nestSquare position square child =
    let w = inchesToPixels square.dimensions.width
        h = inchesToPixels square.dimensions.height
    in Element.container w h (position <| square.dimensions.width / 2) child |> Element.color square.color

viewSquare : Square -> Element
viewSquare square = 
    let w = inchesToPixels square.dimensions.width
        h = inchesToPixels square.dimensions.height
    in Element.spacer w h |> Element.color square.color

intermediateSquares : Painting -> List Square
intermediateSquares painting = 
    let { frame, frameWidth, nucleus, intermediates } = painting
        
        padding : Inches
        padding = intermediatePadding painting
        
        interpolate : Color -> Square -> Square
        interpolate color childSquare =
            { dimensions =
                { width = childSquare.dimensions.width + 2 * padding
                , height = childSquare.dimensions.height + 2 * padding
                }
            , color = color
            } 
    in List.scanr interpolate nucleus intermediates

-- The space between intermediate squares.
intermediatePadding : Painting -> Inches
intermediatePadding { frame, nucleus, frameWidth, intermediates } = 
    let totalIntermediate = frame.dimensions.width
        - 2 * frameWidth
        - nucleus.dimensions.width 
    in totalIntermediate / (toFloat <| 2 * (List.length intermediates))

model : Painting
model =
    { frame =
        { dimensions = 
            { width = 5.75
            , height = 6
            } 
        , color = Color.gray
        }
    , frameWidth = 0.75
    , nucleus = 
        { dimensions =
            { width = 2
            , height = 2
            }
        , color = Color.yellow
        }
    , verticalPerspective = -0.5
    , intermediates = [Color.red, Color.orange]
    }

main : Program Never
main = App.beginnerProgram
    { model = model
    , view = view
    , update = \_ -> identity
    }

