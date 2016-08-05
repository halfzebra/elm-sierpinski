module Sierpinski
    exposing
        ( Point
        , Triangle
        , Painted
        , toPolygon
        , toPainted
        , toFilled
        , equaliteral
        , midpoint
        , recursive
        , embedded
        , children
        )

{-| This module provides a set of helpers for generating Seierpinski fractal
using Graphics module.

# Definition
@docs Point, Triangle, Painted

# Type casting Helpers
@docs toPolygon, toPainted, toFilled

# Geometrical Helpers
@docs equaliteral, midpoint

# Fractal generation
@docs recursive, embedded, children

-}

import Color exposing (blue, Color)
import Collage exposing (filled, polygon, Form, Shape)


{-| Type alias for representing a triangle.

    triangle =
        Triangle (Point 0 0) (Point 5 5) (Point 0 5)


    toPolygon triangle --
-}
type alias Triangle =
    { a : Point
    , b : Point
    , c : Point
    }


{-| A point woth coordinates.

    midpoint (Point 0 0) (Point 5 5) -- Point 2.5 2.5
-}
type alias Point =
    { x : Float, y : Float }


{-| A triangle with color value, ready to be rendered on to Collage.

    painted =
            toPainted (rgb 240 173 0) (Triangle (Point 0 0) (Point 5 5) (Point 0 5))
-}
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


{-| Convert Triangle in to polygon Shape.

    toPolygon (Triangle (Point 0 0) (Point 5 5) (Point 0 5))
-}
toPolygon : Triangle -> Shape
toPolygon { a, b, c } =
    polygon [ ( a.x, a.y ), ( b.x, b.y ), ( c.x, c.y ) ]


{-| Convert triangle in to Painted Triangle, which can be filled with a color and rendered.

    toPainted (rgb 240 173 0) (Triangle (Point 0 0) (Point 5 5) (Point 0 5))
-}
toPainted : Color -> Triangle -> Painted Triangle
toPainted color { a, b, c } =
    { a = a
    , b = b
    , c = c
    , color = color
    }


{-| Converts a triangle in to a polygon, filled with color.

    painted =
            toPainted (rgb 240 173 0) (Triangle (Point 0 0) (Point 5 5) (Point 0 5))

    toFilled painted
-}
toFilled : Painted Triangle -> Form
toFilled { a, b, c, color } =
    filled color (toPolygon { a = a, b = b, c = c })


{-| Produces a list of child triangles from container Triangle and embedded Triangle.


    parent =
        (Triangle (Point 0 0) (Point 5 5) (Point 0 5))

    current =
        embedded parent

    children parent current
-}
children : Triangle -> Triangle -> List Triangle
children parent current =
    [ Triangle parent.a current.a current.c
    , Triangle current.a parent.b current.b
    , Triangle current.c current.b parent.c
    ]


{-| Create a new triangle, using midpoints of parent's sides.

    embedded (Triangle (Point 0 0) (Point 5 5) (Point 0 5))
-}
embedded : Triangle -> Triangle
embedded { a, b, c } =
    Triangle (midpoint a b) (midpoint b c) (midpoint a c)


{-| Recursive function for generating the fractal, requires depth,
list of existing Triangles(used in recursion) and container Triangle for the fractal.

    recursive 5 [] (equaliteral ((toFloat Window.width) / 3))
-}
recursive : Int -> List Triangle -> Triangle -> List Triangle
recursive depth list parent =
    if depth == 0 then
        list
    else
        let
            current =
                embedded parent
        in
            current
                |> children parent
                |> List.map (recursive (depth - 1) [])
                |> List.concat
                |> (::) current
                |> List.append list
