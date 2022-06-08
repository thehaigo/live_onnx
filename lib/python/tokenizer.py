from transformers import GPT2Tokenizer

def encode(text):
  tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
  return tokenizer.encode(text)