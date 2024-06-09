from py.constants import TIKTOKEN_MODEL
import tiktoken


class Tokenizer:
    @staticmethod
    def count_tokens(text: str) -> int:
        encoding = tiktoken.get_encoding(TIKTOKEN_MODEL)
        tokens = encoding.encode(text)
        return len(tokens)
