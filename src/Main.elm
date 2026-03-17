module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Html.Events exposing (on, preventDefaultOn)
import Json.Decode as Decode



-- MODEL


type alias Camera =
    { x : Float -- canvas-space origin (not screen-space pan offset)
    , y : Float
    , z : Float -- zoom factor
    }


type alias Model =
    { camera : Camera
    , drag : Maybe { startX : Float, startY : Float, originX : Float, originY : Float }
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { camera = { x = 500, y = 300, z = 1.0 }
      , drag = Nothing
      }
    , Cmd.none
    )



-- MSG


type Msg
    = PointerDown Float Float
    | PointerMove Float Float
    | PointerUp
    | Wheel Float Float Float Float -- deltaX deltaY cursorX cursorY



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PointerDown x y ->
            ( { model
                | drag =
                    Just
                        { startX = x
                        , startY = y
                        , originX = model.camera.x
                        , originY = model.camera.y
                        }
              }
            , Cmd.none
            )

        PointerMove x y ->
            case model.drag of
                Nothing ->
                    ( model, Cmd.none )

                Just d ->
                    let
                        cam =
                            model.camera
                    in
                    -- pan: divide screen-delta by zoom so pan speed is
                    -- consistent regardless of zoom level
                    ( { model
                        | camera =
                            { cam
                                | x = d.originX + (x - d.startX) / cam.z
                                , y = d.originY + (y - d.startY) / cam.z
                            }
                      }
                    , Cmd.none
                    )

        PointerUp ->
            ( { model | drag = Nothing }, Cmd.none )

        Wheel deltaX deltaY cursorX cursorY ->
            let
                cam =
                    model.camera

                -- Ctrl+wheel = zoom, plain wheel = pan (matches Miro's default)
                -- We keep it simple: deltaY always zooms here.
                -- Swap for deltaX/deltaY pan if preferred.
                factor =
                    if deltaY > 0 then
                        0.9

                    else
                        1.1

                newZ =
                    clamp 0.05 20.0 (cam.z * factor)

                -- zoom toward the cursor:
                -- keep the canvas point under the cursor fixed in screen space
                -- formula: newX = cursorX/newZ - cursorX/oldZ + oldX
                newX =
                    cursorX / newZ - cursorX / cam.z + cam.x

                newY =
                    cursorY / newZ - cursorY / cam.z + cam.y
            in
            ( { model | camera = { cam | x = newX, y = newY, z = newZ } }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    let
        cam =
            model.camera

        transform =
            "scale("
                ++ String.fromFloat cam.z
                ++ ") "
                ++ "translate("
                ++ String.fromFloat cam.x
                ++ "px, "
                ++ String.fromFloat cam.y
                ++ "px)"
    in
    div
        [ class "w-screen h-screen overflow-hidden relative"
        , style "cursor"
            (if model.drag /= Nothing then
                "grabbing"

             else
                "grab"
            )
        , preventDefaultOn "wheel"
            (Decode.map4
                (\dx dy cx cy -> ( Wheel dx dy cx cy, True ))
                (Decode.field "deltaX" Decode.float)
                (Decode.field "deltaY" Decode.float)
                (Decode.field "clientX" Decode.float)
                (Decode.field "clientY" Decode.float)
            )
        , on "pointerdown"
            (Decode.map2 PointerDown
                (Decode.field "clientX" Decode.float)
                (Decode.field "clientY" Decode.float)
            )
        ]
        [ div
            [ class "absolute"
            , style "transform" transform
            , style "transform-origin" "0 0"
            , style "will-change" "transform"
            ]
            [ node42 ]
        ]


node42 : Html Msg
node42 =
    div
        [ class "absolute top-0 left-0 w-[80px] h-[80px] rounded-full bg-ink text-white text-4xl font-mono flex items-center justify-center user-select-none" ]
        [ Html.text "42" ]



-- SUBSCRIPTIONS
-- Pointer move and up are global while dragging, so fast swipes
-- don't orphan the drag when the cursor leaves the element.


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Just _ ->
            Sub.batch
                [ Browser.Events.onMouseMove
                    (Decode.map2 PointerMove
                        (Decode.field "clientX" Decode.float)
                        (Decode.field "clientY" Decode.float)
                    )
                , Browser.Events.onMouseUp
                    (Decode.succeed PointerUp)
                ]

        Nothing ->
            Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
