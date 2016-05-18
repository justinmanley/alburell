module Main exposing (main)

-- Given a specification for a Josef Albers-style "Homage to the Square"
-- painting, calculate the dimensions of each constituent square, and
-- produce a representation of the resulting painting.

import Color as Color exposing (Color)
import Element exposing (Element, Pos, Position, above)
import Text
import Html exposing (Html)
import Html.App as App
import List.Extra as List
import Maybe.Extra as Maybe

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
    , verticalAlignment : VerticalAlignment -- Alignment for the interior squares.
    --  A skew of 0 will cause all interior squares to share their top edge.
    --  A skew of 1 will cause the top interior border to equal the
    --  horizontal interior border.
    , verticalSkew : Float
    -- The colors of the intermediate squares, listed from the outside in.
    , intermediates : List Color 
    }

type VerticalAlignment
    = Top -- The interior squares are aligned with the top of the painting.
    | Bottom -- The interior squares are aligned with the bottom of the painting.

-- A constituent square within an "Homage to the Square"-style painting.
type alias Square =
    { dimensions : Dimensions
    , color : Color
    }

-- Show the calculated dimensions (in inches) for a square.
viewDimensions : Square -> Element
viewDimensions { dimensions, color } =
    let contrastColor : Color
        contrastColor =
            if (Color.toHsl color |> .lightness) < 0.5
            then Color.white
            else Color.black

        viewDimension : String -> Float -> Element
        viewDimension name x = Element.leftAligned
            <| Text.color contrastColor
            <| Text.fromString
            <| name ++ ": " ++ toString x ++ " in."

        pad : Int -> Element -> Element
        pad p el =
            let w = Element.widthOf el + p
                h = Element.heightOf el + p
            in Element.container w h Element.middle el
    in pad 25 <|
        viewDimension "width" dimensions.width `above` viewDimension "height" dimensions.height

view : Painting -> Html {}
view painting = 
    let borderWidth : Inches
        borderWidth = intermediateWidth painting

        borderHeight : Inches
        borderHeight = intermediateHeight painting

        position : Pos -> Pos -> Position
        position = case painting.verticalAlignment of
            Top -> Element.midTopAt
            Bottom -> Element.midBottomAt

        framePosition : Inches -> Position
        framePosition _ = position (Element.absolute <| inchesToPixels (painting.frame.dimensions.width / 2))
            <| Element.absolute
            <| inchesToPixels painting.frameWidth

        intermediatePosition : Inches -> Position
        intermediatePosition width = position (Element.absolute <| inchesToPixels width) 
            <| Element.absolute
            <| inchesToPixels borderHeight
    in Element.toHtml
        <| nestSquare framePosition painting.frame
        <| List.foldr (nestSquare intermediatePosition) (viewSquare painting.nucleus)
        <| intermediateSquares painting

nestSquare : (Inches -> Position) -> Square -> Element -> Element
nestSquare position square child =
    let w = inchesToPixels square.dimensions.width
        h = inchesToPixels square.dimensions.height
    in Element.layers
        [ Element.container w h (position <| square.dimensions.width / 2) child
            |> Element.color square.color
        , viewDimensions square
        ]

viewSquare : Square -> Element
viewSquare square = 
    let w = inchesToPixels square.dimensions.width
        h = inchesToPixels square.dimensions.height
    in Element.layers
        [ Element.spacer w h |> Element.color square.color
        , viewDimensions square
        ]

intermediateSquares : Painting -> List Square
intermediateSquares painting = 
    let { frame, frameWidth, nucleus, intermediates } = painting
        
        padding : Inches
        padding = intermediateWidth painting
        
        interpolate : Color -> Square -> Square
        interpolate color childSquare =
            { dimensions =
                { width = childSquare.dimensions.width + 2 * padding
                , height = childSquare.dimensions.height + 2 * padding
                }
            , color = color
            } 

        squares : List Square
        squares = List.scanr interpolate nucleus intermediates

    -- Return the list of intermediate squares, minus the nucleus.
    -- This removal lets us use the nucleus as a seed for a foldr later.
    in case List.init squares of
        Nothing -> []
        Just ss -> ss

-- The space between intermediate squares.
intermediateWidth : Painting -> Inches
intermediateWidth { frame, nucleus, frameWidth, intermediates } = 
    let totalIntermediate = frame.dimensions.width
        - 2 * frameWidth
        - nucleus.dimensions.width 
    in totalIntermediate / (toFloat <| 2 * (List.length intermediates))

intermediateHeight : Painting -> Inches
intermediateHeight painting = painting.verticalSkew * intermediateWidth painting

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
    , verticalSkew = 0.5
    , verticalAlignment = Bottom
    , intermediates = [Color.red, Color.orange]
    }

main : Program Never
main = App.beginnerProgram
    { model = model
    , view = view
    , update = \_ -> identity
    }

