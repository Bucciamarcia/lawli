from py.logger_config import LoggerConfig
import ffmpeg
import io
import tempfile
from py.constants import LIST_OF_VIDEO_EXTENSIONS, LIST_OF_AUDIO_EXTENSIONS
from py.commons import OpenAiOperations


class TextTranscriber:
    def __init__(self, bytes_list: list[int], format: str):
        self.logger = LoggerConfig().setup_logging()
        self.bytes_list = bytes_list
        self.format = format

    def run(self) -> str:
        """
        Entrypoint. Extracts audio from video.
        """
        self.logger.info("Starting transcription process.")

        # Validate the format
        if self.format in LIST_OF_VIDEO_EXTENSIONS:
            audio_bytes = self._extract_audio()
        elif self.format in LIST_OF_AUDIO_EXTENSIONS:
            if self.format == "mp3":
                self.logger.info("Audio is already in mp3 format.")
                audio_bytes = bytes(self.bytes_list)
            else:
                audio_bytes = self._transform_audio()
        else:
            raise ValueError(f"Format not supported. {self.format}")

        audio_file = io.BytesIO(audio_bytes)
        audio_file.name = "audio.mp3"
        try:
            transcription = OpenAiOperations().extract_text_from_bytefile(audio_file)
            return transcription
        except Exception as e:
            self.logger.error(f"Error while transcribing audio: {e}")
            raise Exception(f"Error while transcribing audio: {e}")

    def _extract_audio(self) -> bytes:
        """Extracts audio from video."""
        with tempfile.NamedTemporaryFile() as temp:
            try:
                temp.write(bytes(self.bytes_list))
                temp.seek(0)
                self.logger.info("Extracting audio from video.")
                out, err = (
                    ffmpeg.input(temp.name)
                    .output("pipe:", format="mp3", audio_bitrate="192k")
                    .run(capture_stdout=True, capture_stderr=True)
                )
                return out
            except Exception as e:
                raise Exception(f"Error while extracting audio: {e}")

    def _transform_audio(self) -> bytes:
        """Transforms the non-mp3 audio into mp3."""
        self.logger.info(f"Transforming audio from {self.format} to mp3.")
        bytes_obj = bytes(self.bytes_list)
        input_buffer = io.BytesIO(bytes_obj)
        output_buffer = io.BytesIO()
        input_stream = ffmpeg.input("pipe:0", format=self.format)
        output_stream = ffmpeg.output(
            input_stream.audio, "pipe:1", format="mp3", audio_bitrate="192k"
        )
        out, err = ffmpeg.run(
            output_stream,
            input=input_buffer.read(),
            capture_stdout=True,
            capture_stderr=True,
        )
        output_buffer.write(out)
        output_buffer.seek(0)
        return output_buffer.read()
