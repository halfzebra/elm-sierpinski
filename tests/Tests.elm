module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Collage exposing (..)
import Sierpinski exposing (..)


all : Test
all =
    let
        triangle =
            Triangle (Point 0 0) (Point 5 5) (Point 0 5)
    in
        describe "Geometrical Helpers"
            [ test "Calculating midpoint" <|
                \() ->
                    Expect.equal
                        (midpoint
                            (Point 13 37)
                            (Point 0 0.7)
                        )
                        (Point 6.5 18.85)
            , test "Building equaliteral triangle for specified width" <|
                \() ->
                    Expect.equal (equaliteral 300)
                        ({ a = { x = 0, y = 129.9038105676658 }
                         , b = { x = 150, y = -129.9038105676658 }
                         , c = { x = -150, y = -129.9038105676658 }
                         }
                        )
            , test "Converting Triangle to polygon Shape" <|
                \() ->
                    Expect.equal (toPolygon (triangle))
                        (polygon [ ( 0, 0 ), ( 5, 5 ), ( 0, 5 ) ])
            ]
