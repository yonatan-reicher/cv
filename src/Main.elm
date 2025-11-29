module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser


type Layout
    = NormalLayout
    | ColumnLayout


type alias Model =
    { layout : Layout
    , removeScaryWords : Bool
    }


type Msg
    = SetLayout Layout
    | SetRemoveScaryWords Bool


meUrl = "me.png"


me =
    div
        [ style "max-width" "100%"
        , style "overflow" "hidden"
        , style "aspect-ratio" "6/5"
        ]
        [ img
            [ src meUrl
            -- Width is 200% because the total width margin is 100%. So the
            -- actual pixel width of the picture is 100%. The margin makes the
            -- image cropped.
            , style "width" "200%"
            , style "margin" "-20% 0 0 -50%"
            ]
            []
        ]



p_ s = p [] [ text s ]


horizontalSeparator =
    div [ class "horizontal-separator" ] []


abstract model =
    div
        []
        [ p [] [ text """
            I am a """, strong [] [ text "Master of Science" ], text """ student
            researcher at the """, strong [] [ text """Technion's Software
            Engineering Lab""" ], text """ in the department of Computer Science.
        """ ]
        , if not model.removeScaryWords then
            p_ """
                I am interested in Programming Languages, Proof Assistants, making
                better type systems for better code, and all domains of software
                engineering (graphics, games, systems, ML, full-stack development,
                etc.)
            """
        else
            p_ """
                I am interested in software engineering and in making humans
                write better code, but also in graphics, games, systems, machine
                learning, full-stack developement and everything that has code.
            """
        , p_ """
            I am currently working towards both a Bachelor's and a Master's of
            Science in Parallel. I had the chance to work with Shachar Itzaki
            and Hila Peleg, along with other members of our lab, on a number of
            projects related to verification, programming languages and software
            engineering.
        """
        , p_ """
            I had the chance to be a Teaching Assistant for two Technion courses,
            as well as a Magshimim course. I also got the chance to teach a
            software engineering class for high-schoolers for a year.
        """
        ]


colorGray = style "color" "gray"


{-| This element shows my name, a picture and my academic title -}
titles { showPicture, rightPadding } =
    header
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "box-sizing" "border-box"
        , style "width" "50%"
        , if rightPadding then style "padding-right" "15%" else style "" ""
        -- 15% of the original width, so 30% of the actual width
        ]
        [ h1
            [ style "margin" "0"
            , style "padding" "0"
            -- Get the size just right!
            , style "font-size" "clamp(1rem, 3.7vw, 2.513em)"
            , style "transform" "translateX(1.5px)"
            , style "text-wrap" "nowrap"
            ]
            [ text "Jonathan Reicher" ]
        , if showPicture then me else text ""
        , span
            [ colorGray
            , style "margin-top" "10px"
            ]
            [ text "M.Sc student @ Technion CS" ]
        ]


headerRow model =
    div
        (case model.layout of
            NormalLayout ->
                [ style "display" "flex"
                , style "flex-direction" "row"
                ]
            ColumnLayout ->
                [ style "display" "flex"
                , style "flex-direction" "column"
                , style "align-items" "center"
                ])
        [ titles (case model.layout of
            NormalLayout -> { showPicture = True, rightPadding = True }
            ColumnLayout -> { showPicture = False, rightPadding = False } )
        , div
            [ style "flex-basis" "50%"
            , style "display" "flex"
            , style "flex-direction" "column"
            , style "align-items" "center"
            , style "justify-content" "center"
            ]
            [ abstract model
            ]
        ]


education =
    div
        []
        [ h2 [] [ text "Education" ]
        , ul []
            [ li []
                [ strong [] [ text "B.Sc. + M.Sc of Software En." ]
                , text ", Technion (2025-Today)"
                ]
            , li []
                [ strong [] [ text "Magshimim" ]
                , text " (2019-2022)"
                ]
            , li []
                [ text "Talented Youth in Mathematics"
                , text ", Bar Ilan (2019-2022)"
                ]
            , li []
                [ text "Academy in High School"
                , text ", Open University (2019-2022)"
                ]
            ]
        ]


projects =
    div
        []
        [ h2 [] [ text "Projects" ]
        , p [ style "margin-bottom" "0" ] [ text """
            Some interesting projects I had the chance to work on:
        """ ]
        , ul
            [ style "margin-top" "5px" ]
            [ li [] [ text "Lean 4 Research Project (2025)" ]
            , li [] [ text "3D model CPU renderer (2025)" ]
            , li [] [ text "Data Science project for IDF (2024)" ]
            , li [] [ text "Dependent Typing with Equality Saturation, Technion (2023-2024)" ]
            , li [] [ text "Deep Learning final project for Magshimim (2021-2022)" ]
            , li [] [ text "C-to-x86 compiler", text " (2019-2020)" ]
            ]
        ]


work =
    div
        []
        [ h2 [] [ text "Work Experience" ]
        , ul
            []
            [ li []
                [ strong [] [ text "Software Engineer" ]
                , text ", Photomyne (2022)"
                ]
            , li [] [ text "Automation Engineer, DealHub (2021)" ]
            ]
        ]


teaching =
    div
        []
        [ h2 [] [ text "Teaching Experience" ]
        , ul
            []
            [ li [] [ text "Select Topics in Formal Proofs (2025)" ]
            , li [] [ text "Programming Languages (2025)" ]
            , li [] [ text "Software Engineering, Ort Guttman High School (2023-2024)" ]
            , li [] [ text "Intro to Programming, Magshimim (2021)" ]
            ]
        ]


subColumn c =
    div
        [ style "width" "50%"
        , style "display" "inline-block"
        , style "vertical-align" "top"
        ]
        c


contentRow model =
    case model.layout of
        NormalLayout ->
            div
                []
                [ subColumn
                    [ education
                    , teaching
                    ]
                , subColumn
                    [ work
                    , projects
                    ]
                ]
        ColumnLayout ->
            div
                []
                [ education
                , work
                , teaching
                , projects
                ]


configure model =
    p
        [ class "no-print" ]
        [ text "Single column "
        , input
            [ type_ "checkbox"
            , style "filter" "saturate(0)"
            , checked (model.layout == ColumnLayout)
            , onCheck (\b -> if b
                then SetLayout ColumnLayout
                else SetLayout NormalLayout)
            ]
            []
        , text " Remove jargon "
        , input
            [ type_ "checkbox"
            , style "filter" "saturate(0)"
            , checked model.removeScaryWords
            , onCheck SetRemoveScaryWords
            ]
            []
        ]


footerRow model =
    footer
        []
        [ horizontalSeparator
        , div
            [ style "opacity" "70%"
            ]
            [ p 
                []
                [ text """
                    This is made with a programming language called Elm, which
                    I love.
                """
                , br [] []
                , text "Source code can be found on "
                , a [ href "github.com/yonatan-reicher/cv" ] [ text "GitHub" ]
                , text "."
                ]
            , configure model
            ]
        ]


mainColumn model =
    div
        [ style "max-width" (case model.layout of
            NormalLayout -> "1000px"
            ColumnLayout -> "700px")
        , style "margin" "auto"
        , style "margin-top" "40px"
        ]
        [ headerRow model
        , horizontalSeparator
        , contentRow model
        , footerRow model
        ]


view : Model -> Html Msg
view model =
    div
        [ style "margin" "0 40px"
        ]
        [ node "link"
            [ rel "stylesheet"
            , type_ "text/css"
            , href "src/style.css"
            ]
            []
        , mainColumn model
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLayout l -> { model | layout = l }
        SetRemoveScaryWords r -> { model | removeScaryWords = r }


init : Model
init =
    { layout = NormalLayout
    , removeScaryWords = False
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


