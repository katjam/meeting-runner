module RunnerTest exposing (suite)

import Expect
import Test exposing (..)


suite : Test
suite =
    describe "Expect anything!"
        [ test "true is true" <|
            \_ ->
                True
                    |> Expect.equal True
        ]
