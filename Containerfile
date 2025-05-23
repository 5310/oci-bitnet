FROM python:3.12-alpine
RUN apk add --no-cache build-base cmake clang git

RUN git clone --recursive --depth 1 https://github.com/microsoft/BitNet.git && rm -rf BitNet/.git

WORKDIR /BitNet

RUN pip install --no-cache-dir -r requirements.txt

RUN python3 utils/codegen_tl2.py --model Llama3-8B-1.58-100B-tokens --BM 256,128,256,128 --BK 96,96,96,96 --bm 32,32,32,32

RUN cmake -B build -DBITNET_X86_TL2=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++

RUN cmake --build build --target llama-cli --config Release

COPY ggml-model-i2_s.gguf .

ENTRYPOINT ["python3", "run_inference.py", "-m", "ggml-model-i2_s.gguf"]

CMD ["-cnv", "-p", "You are a conversational AI. Help the user any way you can."]

LABEL RUN='podman run --rm ${IMAGE}'
LABEL RUN_W_CUSTOM_ARGS='podman run --rm ${IMAGE}	<your arguments> -p "<your prompt>'
LABEL RUN_FULLY_CUSTOM='podman run --rm -it -v /some/host/path:/BitNet/models ${IMAGE} --entrypoint sh'