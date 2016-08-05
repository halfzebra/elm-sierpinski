module Sierpinski
    exposing
        ( Point
        , Triangle
        , Painted
        , toPolygon
        , toPainted
        , toFilled
        , equaliteral
        , getCenter
        , recursive
        , getCurrent
        , children
        )

{-| This module provides a set of helpers for generating Seierpinski fractal
using Graphics module.

# Definition
@docs Point, Triangle, Painted

# Common Helpers
@docs toPolygon, toPainted, toFilled

# Geometrical Helpers
@docs equaliteral, getCenter

# Fractal generation
@docs recursive, getCurrent, children

-}

import Color exposing (blue, Color)
import Collage exposing (filled, polygon, Form, Shape)


{-| Type alias for representing a triangle
-}
type alias Triangle =
    { a : Point
    , b : Point
    , c : Point
    }


{-|-}
type alias Point =
    { x : Float, y : Float }


{-| -}
type alias Painted a =
    { a | color : Color }


{-| Calculate the midpoint between two points.

    midpoint (Point 0 0) (Point 5 5)
-}
midpoint : Point -> Point -> Point
midpoint p1 p2 =
    Point ((p1.x + p2.x) / 2) ((p1.y + p2.y) / 2)


{-| Produces an initial container equaliteral triangle for the fractal.

    equaliteral ((toFloat Window.width) / 3)
-}
equaliteral : Float -> Triangle
equaliteral side =
    let
        h =
            side * (sqrt 3 / 2)
    in
        Triangle
            (Point 0 (h / 2))
            (Point (side / 2) (-h / 2))
            (Point (-side / 2) (-h / 2))


{-| Convert Triangle in to Shape, so it could be rendered -}
toPolygon : Triangle -> Shape
toPolygon { a, b, c } =
    polygon [ ( a.x, a.y ), ( b.x, b.y ), ( c.x, c.y ) ]


{-| -}
toPainted : Color -> Triangle -> Painted Triangle
toPainted color { a, b, c } =
    { a = a
    , b = b
    , c = c
    , color = color
    }


{-| Converts a triangle in to a triangle with color.
-}
toFilled : Painted Triangle -> Form
toFilled { a, b, c, color } =
    filled color (toPolygon { a = a, b = b, c = c })


{-| Produces a list of child triangles
-}
children : Triangle -> Triangle -> List Triangle
children parent current =
    [ Triangle parent.a current.a current.c
    , Triangle current.a parent.b current.b
    , Triangle current.c current.b parent.c
    ]


{-| -}
getCurrent : Triangle -> Triangle
getCurrent { a, b, c } =
    Triangle (midpoint a b) (midpoint b c) (midpoint a c)


{-| Recursive function for generating the fractal.


-}
recursive : Int -> List Triangle -> Triangle -> List Triangle
recursive depth list parent =
    if depth == 0 then
        list
    else
        let
            current =
                getCurrent parent
        in
            current
                |> children parent
                |> List.map (recursive (depth - 1) [])
                |> List.concat
                |> (::) current
                |> List.append list
