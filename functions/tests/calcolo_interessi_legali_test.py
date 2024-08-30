import unittest
from py.functions.calcolo_interessi_legali import CalcoloInteressiLegali
from unittest.mock import Mock, patch


class TestCalcoloInteressiLegali(unittest.TestCase):

    def setUp(self):
        self.gpt_response = """{"data_iniziale": "01/01/2021",
        "data_finale": "01/01/2022",
        "capitale_iniziale": 1000,
        "capitalizzazione": "annuale"}"""

    @patch("py.functions.calcolo_interessi_legali.OpenAI")
    def test_calcolo_interessi_legali(self, MockOpenAI):
        # Create a mock instance of the OpenAI class
        mock_instance = MockOpenAI.return_value
        # Mock the beta.chat.completions.parse method
        mock_instance.beta.chat.completions.parse.return_value = Mock(
            choices=[Mock(message=Mock(content=self.gpt_response))]
        )

        tester = CalcoloInteressiLegali("text")
        # Run the function under test
        response = tester.run()

        # Assert the response is a dictionary
        self.assertIsInstance(response, dict)
        # Further assertions can be added here to check the content of the dictionary
        self.assertEqual(response["data_iniziale"], "01/01/2021")
        self.assertEqual(response["data_finale"], "01/01/2022")
        self.assertEqual(response["capitale_iniziale"], 1000)
        self.assertEqual(response["capitalizzazione"], "annuale")


"""     def test_real_gpt(self):
        tester = CalcoloInteressiLegali("text")

        response = tester.run()

        self.assertIsInstance(response, dict)
        self.assertIn("data_iniziale", response)
        self.assertIn("data_finale", response)
        self.assertIn("capitale_iniziale", response)
        self.assertIn("capitalizzazione", response) """


if __name__ == "__main__":
    unittest.main()
