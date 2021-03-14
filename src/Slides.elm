module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Html exposing (Html, a, button, div, h1, h2, h3, hr, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Markdown
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)
import Time exposing (Posix)


{-| Model type of the custom content
-}
type alias Model =
    { displayTime : Float
    , startTime : Float
    , timerStarted : Bool
    }


{-| Message type for the custom content
-}
type Message
    = Tick Posix
    | AddStartMinute
    | StartStopPressed Bool


{-| Type for custom content
-}
type alias CustomContent =
    Content Model Message


{-| Type for custom slide
-}
type alias CustomSlide =
    Slide Model Message


{-| Update function for the custom content
-}
update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Tick _ ->
            ( { model | displayTime = model.displayTime - 1000 }, Cmd.none )

        AddStartMinute ->
            ( { model | startTime = model.startTime + 60 }, Cmd.none )

        StartStopPressed state ->
            ( { model
                | displayTime = model.startTime * 1000
                , timerStarted = not state
              }
            , Cmd.none
            )


{-| View function for the custom content that shows time remaining
-}
view : Model -> Html Message
view model =
    div
        [ class "stopwatch" ]
        [ span []
            [ if
                model.startTime
                    /= 0
                    && model.timerStarted
              then
                if model.displayTime > 0 then
                    text
                        ((round model.displayTime // 1000 |> String.fromInt)
                            ++ " seconds"
                        )

                else
                    text "Time's up"

              else
                button
                    [ onClick AddStartMinute ]
                    [ text (String.fromFloat model.startTime) ]
            ]
        , button [ onClick (StartStopPressed model.timerStarted) ]
            [ if model.timerStarted then
                text ""

              else
                text "Go !"
            ]
        ]


{-| Inputs for the custom content
-}
subscriptions : Model -> Sub Message
subscriptions model =
    if model.timerStarted then
        Time.every 1000 Tick

    else
        Sub.none


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ [ slideHeading "Needs, experiences and ideation"
      , item (h2 [] [ text "A workshop with teaching professionals for The Gallery at The Point" ])
      , slideHr
      , bullets
            [ bulletLink "The Gallery at the Point website" "https://thepoint.org.uk/the-point/gallery/"
            , bulletLink "The miro board" "https://miro.com/app/board/o9J_lT0_Z5k=/"
            ]
      ]
    , [ slideHeading "The plan"
      , slideHr
      , bullets
            [ bullet "Quick Intros"
            , bullet "Read through stories - add and amend"
            , bullet "Figure out which are the most important"
            , bullet "Take a look at some of our resource ideas"
            , bullet "Map out current experience for the most important need"
            , bullet "Suggest solutions"
            ]
      , item (h2 [] [ text "Any questions before we start?" ]) |> hide
      ]
    , [ slideHeading "Who are we, why are we here?"
      , slideHr
      , container (div [])
            [ timedHeading "3" "In turn" "Say 2 things"
            , bullets
                [ bullet "something about yourself"
                , bullet "why you came today"
                ]
            ]
            |> hide
      ]
    , [ slideHeading "Things we need"
      , slideH3 "(that The Point might provide)"
      , slideHr
      , timedHeading "5" "Independently" "Read the need statements"
      , slideP "Use the numbers as reference and note down:"
      , bullets
            [ bullet "if it is not true"
            , bullet "if it could be worded differently to make it more true"
            , bullet "if we have missed out something you think we could provide that you need"
            ]
      ]
    , [ item (img [ src "./userneeds.png" ] [])
      ]
    , [ slideHeading "Things we need"
      , slideH3 "(that The Point might provide)"
      , slideHr
      , timedHeading "8" "Together" "Talk through our notes"
      , bullets
            [ bullet "set aside any that we have agreed are not true"
            , bullet "add any that we agree are important"
            , bullet "make agreed amendments"
            ]
      ]
    , [ slideHeading "Things we need"
      , slideH3 "(that The Point might provide)"
      , slideHr
      , timedHeading "2" "Independently" "Choose 3"
      , slideP "Note down the 3 that are most true and most important to you now"
      , slideP "If you had trouble deciding, was there one more you's like to include?" |> hide
      ]
    , [ slideHeading "Things we need"
      , slideH3 "(that The Point might provide)"
      , slideHr
      , timedHeading "5" "Together" "Choose 1"
      , slideP "Agree one of the needs that we can look at in more detail together now"
      ]
    , [ slideHeading "A look at some resources"
      ]
    , [ slideHeading "Map out current experience"
      , bullets
            [ bullet ""
            , bullet ""
            ]
      ]
    , [ slideHeading "Ideas!"
      , timedHeading "5" "Independently" "How might we..."
      ]
    , [ slideHeading "How much effort? How much value?"
      ]
    ]
        |> List.map paddedSlide


slideHeading : String -> CustomContent
slideHeading title =
    item (h1 [] [ text title ])


slideHr : CustomContent
slideHr =
    item (hr [] [])


slideH2 : String -> CustomContent
slideH2 heading =
    item (h2 [] [ text heading ])


slideH3 : String -> CustomContent
slideH3 heading =
    item (h3 [] [ text heading ])


slideP : String -> CustomContent
slideP paragraph =
    item (p [] [ text paragraph ])


slidePMarkdown : String -> CustomContent
slidePMarkdown paragraph =
    item (Markdown.toHtml [] paragraph)


timedHeading : String -> String -> String -> CustomContent
timedHeading minutes who heading =
    let
        label =
            if minutes == "1" then
                " minute"

            else
                " minutes"
    in
    container (h2 [])
        [ item (text heading)
        , item (span [ class "who" ] [ text who ])
        , item (span [ class "time" ] [ text (minutes ++ label) ])
        ]


bullets : List CustomContent -> CustomContent
bullets =
    container (ul [])


bullet : String -> CustomContent
bullet str =
    item (li [] [ text str ])


bulletLink : String -> String -> CustomContent
bulletLink str url =
    item (li [] [ a [ href url ] [ text str ] ])


{-| Custom slide that sets the padding and appends the custom content
-}
paddedSlide : List CustomContent -> CustomSlide
paddedSlide content =
    slide
        [ container
            (div [ class "slides", style "padding" "50px 100px" ])
            (content
                ++ [ custom
                        { displayTime = 0
                        , startTime = 0
                        , timerStarted = False
                        }
                   , item
                        (div [ class "footer" ]
                            [ text ""
                            ]
                        )
                   ]
            )
        ]
