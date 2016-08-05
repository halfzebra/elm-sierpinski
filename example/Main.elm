module Main exposing (..)

import Random
import Color exposing (rgb, Color)
import Collage exposing (collage, alpha)
import Element exposing (toHtml)
import Html exposing (Html)
import Html.Lazy exposing (lazy)
import Html.App exposing (programWithFlags)
import Window exposing (resizes, Size)
import Mouse exposing (moves, Position)
import Sierpinski


init : Size -> ( Model, Cmd Msg )
init { width, height } =
    ( { window = Size width height, depth = 0 }, Cmd.none )


type alias Model =
    { window : Size
    , depth : Int
    }


view : Model -> Html Msg
view model =
    let
        { width, height } =
            model.window

        side =
            (toFloat width) / 3

        fractal =
            Sierpinski.recursive model.depth [] (Sierpinski.equaliteral side)

        colors =
            getRandomizedColors (List.length fractal)

        toForm color triangle =
            Sierpinski.toFilled (Sierpinski.toPainted color triangle)
    in
        Sierpinski.recursive model.depth [] (Sierpinski.equaliteral side)
            |> List.map2 toForm colors
            |> collage width height
            |> toHtml


main : Program Size
main =
    programWithFlags
        { view = lazy view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resizes size ->
            ( { model | window = size }, Cmd.none )

        Mouse pos ->
            let
                width =
                    toFloat model.window.width

                posX =
                    toFloat pos.x

                depth =
                    round ((posX / width) * 10)
            in
                if model.depth /= depth then
                    ( { model | depth = depth }, Cmd.none )
                else
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ resizes Resizes
        , moves Mouse
        ]


type Msg
    = Resizes Size
    | Mouse Position


getRandomizedColors : Int -> List Color
getRandomizedColors length =
    let
        makeStep gen =
            Random.step gen (Random.initialSeed 1337)
    in
        Random.list length (Random.int 1 4)
            |> Random.map (List.map getColor)
            |> makeStep
            |> fst


getColor : Int -> Color
getColor id =
    case id of
        1 ->
            rgb 240 173 0

        2 ->
            rgb 127 209 59

        3 ->
            rgb 6 181 204

        _ ->
            rgb 90 99 120
