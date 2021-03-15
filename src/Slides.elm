module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Html exposing (Html, a, br, button, div, h1, h2, h3, hr, img, li, p, span, text, ul)
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
    [ ( [ slideHeading "Needs, experiences and ideation"
        , item (h2 [] [ text "A workshop with teaching professionals for The Gallery at The Point" ])
        , slideHr
        , bullets
            [ bulletLink "The Gallery at the Point website" "https://thepoint.org.uk/the-point/gallery/"
            , bulletLink "The miro board" "https://miro.com/app/board/o9J_lT0_Z5k=/"
            ]
        ]
      , ""
      )
    , ( [ slideHeading "The plan"
        , slideHr
        , bullets
            [ bullet "Quick Intros"
            , bullet "Take a look at some of our resource ideas"
            , bullet "Read through stories - add and amend"
            , bullet "Figure out which are the most important"
            , bullet "Map out current experience for the most important need"
            , bullet "Suggest solutions"
            ]
        , item (h2 [] [ text "Any questions before we start?" ]) |> hide
        ]
      , ""
      )
    , ( [ slideHeading "Who are we, why are we here?"
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
      , "1605"
      )
    , ( [ slideHeading "A look at some resources"
        , timedHeading "8" "Together" "Helen & Amy share"
        ]
      , "1613"
      )
    , ( [ slideHeading "Things we need"
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
      , ""
      )
    , ( [ slideHeading "Things we need"
        , container (div [ class "compact" ])
            [ spanText "1. I need to be able to sign up to receive information directly so that members of the management team (or person who filters incoming content) cannot accidentally cause me miss out on opportunities"
            , spanText "2. I need access to regular training opportunities  so that I can continue my professional development and provide exciting, inspirational lessons for my pupils"
            , spanText "5. I need to see resources in advance if I am bringing my class for a visit so that I can plan my lessons"
            , spanText "3. I need to know where to go to access practical information and engagement details so that I am not wasting time searching"
            , spanText "4. I need access to regularly updated information in one place to keep me up to date so that I don't miss out on opportunities for me or my pupils"
            , spanText "6. I need\u{00A0} to be able to book workshops with professional artists so that my pupils have a richer learning experience and\u{00A0}I can learn new skills and be inspired"
            , spanText "8. I need the opportunity to input into programming at The Point so that exhibitions and resources are relevant to what I am teaching in the classroom"
            , spanText "7. I\u{00A0} need online artist workshops so we can access enriching experiences in school and overcome the barriers to organising out of school visits"
            , spanText "9. I need an online space for my pupils to share their artwork to give them a sense of achievement, document their learning and share with friends/family/peers"
            , spanText "10. I need resources to be directly relevant to the curriculum so that I can use them to deliver my lessons and achieve KPI's"
            , spanText "11. I need to be able to see or sign up for regular short  updates to inspire me and direct me to the right place so that I can find out about opportunities that are relevant to me"
            , spanText "12. I need to know what is going to be on show in the gallery at The Point many months in advance to enable me to decide if and how I can engage with the opportunities on offer"
            , spanText "13. I need to understand what information is relevant to me in the messaging coming out of darts so that I don't stop listening when 9 of 10 messages are not for me"
            , spanText
                "14. I need to know who the key people are so that I can build a rapport with staff and feel connected and invested in the gallery offer"
            , spanText
                "15. I need to be able to deliver cultural content to my students free of charge because transport costs alone are expensive so that students can access richer content related to curriculum"
            ]
        ]
      , "1620"
      )
    , ( [ slideHeading "Things we need"
        , slideH3 "(that The Point might provide)"
        , slideHr
        , timedHeading "8" "Together" "Talk through our notes"
        , bullets
            [ bullet "set aside any that we have agreed are not true"
            , bullet "add any that we agree are important"
            , bullet "make agreed amendments"
            ]
        , item (a [ href "https://miro.com/app/board/o9J_lT0_Z5k=" ] [ text "Miro board" ])
        ]
      , "1628"
      )
    , ( [ slideHeading "Things we need"
        , slideH3 "(that The Point might provide)"
        , slideHr
        , timedHeading "2" "Independently" "Choose 3"
        , slideP "Note down the 3 that are most true and most important to you now"
        , slideP "If you had trouble deciding, was there one more you'd like to include?" |> hide
        ]
      , "1630"
      )
    , ( [ slideHeading "Things we need"
        , slideH3 "(that The Point might provide)"
        , slideHr
        , timedHeading "5" "Together" "Choose 1"
        , bullets
            [ bullet "Agree one of the needs that we can look at in more detail together now"
            , bullet "Copy that need into excel template"
            ]
        , item (a [ href "https://docs.google.com/spreadsheets/d/1qjc5p0F6XZfbqMRVwXfeZkxhDG34ZvnToGmFIEhcHeI/edit#gid=0" ] [ text "Excel template" ])
        , item (br [] [])
        , item (a [ href "https://miro.com/app/board/o9J_lT0_Z5k=" ] [ text "Miro board" ])
        ]
      , "1638"
      )
    , ( [ slideHeading "Map out current experience"
        , bullets
            [ bullet "Fill in: who, need, start, ideal end"
            , bullet "First Step is starting point"
            , bullet "Micro step is goal for that one"
            , bullet "What do they do, say and feel to reach that goal"
            , bullet "Next step ... repeat"
            , bullet "Where is it annoying, difficult, impossible now?"
            , bullet "Generate a 'How might we..' statement"
            ]
        ]
      , "1645"
      )
    , ( [ slideHeading "Ideas!"
        , timedHeading "5" "Independently" "How might we..."
        ]
      , "1652"
      )
    , ( [ slideHeading "How much effort? How much value?"
        ]
      , "1700!"
      )
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


spanText : String -> CustomContent
spanText str =
    item (span [] [ text str ])


bulletLink : String -> String -> CustomContent
bulletLink str url =
    item (li [] [ a [ href url ] [ text str ] ])


{-| Custom slide that sets the padding and appends the custom content
-}
paddedSlide : ( List CustomContent, String ) -> CustomSlide
paddedSlide ( content, extraBit ) =
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
                            [ text extraBit
                            ]
                        )
                   ]
            )
        ]
