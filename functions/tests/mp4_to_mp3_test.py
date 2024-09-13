import os
import io
import unittest
from unittest import TestCase
from unittest.mock import patch

from py.functions.transcribe_video_audio import TextTranscriber


class TestTranscribeVideoAudio(TestCase):
    def setUp(self):
        # Define the base filename and the directory containing the test files
        self.base_filename = "testaudio"
        self.test_dir = "tests"

        # List of all formats to test
        self.formats = [
            "mp4",
            "mkv",  # Existing formats
            "avi",
            "mov",
            "wmv",
            "flv",
            "mp3",
            "wav",
            "flac",
            "ogg",
            "m4a",
        ]

        # Dictionary to hold bytes data and bytes list for each format
        self.test_files = {}

        for fmt in self.formats:
            file_path = os.path.join(self.test_dir, f"{self.base_filename}.{fmt}")
            if not os.path.isfile(file_path):
                self.fail(f"Test file '{file_path}' does not exist.")

            with open(file_path, "rb") as f:
                bytes_data = f.read()
                bytes_list = list(bytes_data)
                self.test_files[fmt] = {
                    "bytes_data": bytes_data,
                    "bytes_list": bytes_list,
                }

    @patch(
        "py.functions.transcribe_video_audio.OpenAiOperations.extract_text_from_bytefile"
    )
    def test_extract_audio(self, mock_extract_text):
        """
        Test the _extract_audio method for all supported formats.
        Ensures that the method returns bytes for each format and that the audio is in MP3 format.
        """
        # Configure the mock to return a dummy transcription
        mock_extract_text.return_value = "This is a mock transcription."

        for fmt in self.formats:
            with self.subTest(format=fmt):
                bytes_list = self.test_files[fmt]["bytes_list"]
                transcriber = TextTranscriber(bytes_list, fmt)
                audio_bytes = transcriber._extract_audio()

                # Assert that the extracted audio is bytes
                self.assertIsInstance(
                    audio_bytes,
                    bytes,
                    msg=f"Extracted audio is not bytes for format '{fmt}'.",
                )

                # Optional: Check MP3 signature (ID3 tag or MPEG frames)
                # ID3 tag starts with 'ID3'
                if audio_bytes.startswith(b"ID3") or audio_bytes[0:2] == b"\xff\xfb":
                    is_mp3 = True
                else:
                    is_mp3 = False
                self.assertTrue(
                    is_mp3,
                    msg=f"Extracted audio is not in MP3 format for format '{fmt}'.",
                )

    @patch(
        "py.functions.transcribe_video_audio.OpenAiOperations.extract_text_from_bytefile"
    )
    def test_run_transcription(self, mock_extract_text):
        """
        Test the run method for all supported formats.
        Ensures that the method returns a string containing the transcription and that the audio is in MP3 format.
        """
        # Configure the mock to return a dummy transcription
        mock_extract_text.return_value = "This is a mock transcription."

        for fmt in self.formats:
            with self.subTest(format=fmt):
                bytes_list = self.test_files[fmt]["bytes_list"]
                transcriber = TextTranscriber(bytes_list, fmt)
                try:
                    transcription = transcriber.run()

                    # Assert that the transcription is a string
                    self.assertIsInstance(
                        transcription,
                        str,
                        msg=f"Transcription is not a string for format '{fmt}'.",
                    )

                    # Assert that the transcription matches the mock
                    self.assertEqual(
                        transcription,
                        "This is a mock transcription.",
                        msg=f"Transcription does not match the mock for format '{fmt}'.",
                    )

                    # Ensure that the mock was called once
                    mock_extract_text.assert_called_once()

                    # Get the audio_file passed to the mock
                    args, kwargs = mock_extract_text.call_args
                    audio_file = args[0]

                    # Assert that the audio_file is a BytesIO object
                    self.assertIsInstance(
                        audio_file,
                        io.BytesIO,
                        msg=f"The audio file passed is not a BytesIO object for format '{fmt}'.",
                    )

                    # Assert that the audio_file name is 'audio.mp3'
                    self.assertEqual(
                        audio_file.name,
                        "audio.mp3",
                        msg=f"The audio file name is not 'audio.mp3' for format '{fmt}'.",
                    )

                    # Optional: Check MP3 signature in the audio_file bytes
                    audio_file.seek(0)
                    audio_bytes = audio_file.read()
                    if (
                        audio_bytes.startswith(b"ID3")
                        or audio_bytes[0:2] == b"\xff\xfb"
                    ):
                        is_mp3 = True
                    else:
                        is_mp3 = False
                    self.assertTrue(
                        is_mp3,
                        msg=f"The audio file passed is not in MP3 format for format '{fmt}'.",
                    )

                except Exception as e:
                    self.fail(
                        f"Transcription raised an exception for format '{fmt}': {e}"
                    )

                finally:
                    # Reset the mock for the next iteration
                    mock_extract_text.reset_mock()

    @patch(
        "py.functions.transcribe_video_audio.OpenAiOperations.extract_text_from_bytefile"
    )
    def test_audio_only_formats(self, mock_extract_text):
        """
        Test audio-only formats to ensure they are handled correctly.
        Assumes that formats like 'mp3', 'wav', etc., are audio-only.
        Ensures that the transcription is returned and audio is in MP3 format.
        """
        # Configure the mock to return a dummy transcription
        mock_extract_text.return_value = "This is a mock transcription."

        audio_formats = ["mp3", "wav", "flac", "ogg", "m4a"]
        for fmt in audio_formats:
            with self.subTest(format=fmt):
                bytes_list = self.test_files[fmt]["bytes_list"]
                transcriber = TextTranscriber(bytes_list, fmt)
                try:
                    transcription = transcriber.run()

                    # Assert that the transcription is a string
                    self.assertIsInstance(
                        transcription,
                        str,
                        msg=f"Transcription is not a string for audio format '{fmt}'.",
                    )

                    # Assert that the transcription matches the mock
                    self.assertEqual(
                        transcription,
                        "This is a mock transcription.",
                        msg=f"Transcription does not match the mock for audio format '{fmt}'.",
                    )

                    # Ensure that the mock was called once
                    mock_extract_text.assert_called_once()

                    # Get the audio_file passed to the mock
                    args, kwargs = mock_extract_text.call_args
                    audio_file = args[0]

                    # Assert that the audio_file is a BytesIO object
                    self.assertIsInstance(
                        audio_file,
                        io.BytesIO,
                        msg=f"The audio file passed is not a BytesIO object for audio format '{fmt}'.",
                    )

                    # Assert that the audio_file name is 'audio.mp3'
                    self.assertEqual(
                        audio_file.name,
                        "audio.mp3",
                        msg=f"The audio file name is not 'audio.mp3' for audio format '{fmt}'.",
                    )

                    # Optional: Check MP3 signature in the audio_file bytes
                    audio_file.seek(0)
                    audio_bytes = audio_file.read()
                    if (
                        audio_bytes.startswith(b"ID3")
                        or audio_bytes[0:2] == b"\xff\xfb"
                    ):
                        is_mp3 = True
                    else:
                        is_mp3 = False
                    self.assertTrue(
                        is_mp3,
                        msg=f"The audio file passed is not in MP3 format for audio format '{fmt}'.",
                    )

                except Exception as e:
                    self.fail(
                        f"Transcription raised an exception for audio format '{fmt}': {e}"
                    )

                finally:
                    # Reset the mock for the next iteration
                    mock_extract_text.reset_mock()

    @patch(
        "py.functions.transcribe_video_audio.OpenAiOperations.extract_text_from_bytefile"
    )
    def test_non_supported_format(self, mock_extract_text):
        """
        Test that an unsupported format raises a ValueError.
        """
        # Configure the mock (not necessary here since exception should be raised before calling it)
        mock_extract_text.return_value = "This is a mock transcription."

        unsupported_format = "xyz"
        bytes_list = self.test_files.get(unsupported_format, {}).get("bytes_list", [])

        if not bytes_list:
            # Create a dummy bytes list for the unsupported format
            bytes_list = list(b"dummy data")

        transcriber = TextTranscriber(bytes_list, unsupported_format)
        with self.assertRaises(ValueError) as context:
            transcriber.run()

        self.assertIn("Format not supported.", str(context.exception))

        # Ensure that the mock was never called
        mock_extract_text.assert_not_called()

    @patch(
        "py.functions.transcribe_video_audio.OpenAiOperations.extract_text_from_bytefile"
    )
    def test_error_in_transcription(self, mock_extract_text):
        """
        Test that if OpenAiOperations.extract_text_from_bytefile raises an exception,
        the run method also raises an exception.
        """
        # Configure the mock to raise an exception
        mock_extract_text.side_effect = Exception("API failure.")

        for fmt in self.formats:
            with self.subTest(format=fmt):
                bytes_list = self.test_files[fmt]["bytes_list"]
                transcriber = TextTranscriber(bytes_list, fmt)
                with self.assertRaises(Exception) as context:
                    transcriber.run()

                self.assertIn(
                    "Error while transcribing audio: API failure.",
                    str(context.exception),
                )

                # Ensure that the mock was called once
                mock_extract_text.assert_called_once()

                # Reset the mock for the next iteration
                mock_extract_text.reset_mock()


# To run the tests, you can include the following block.
# However, in many test runners, this is not necessary.

if __name__ == "__main__":
    unittest.main()
