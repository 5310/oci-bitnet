> Forked from https://github.com/kth8/bitnet/

Simple OCI container image to run [BitNet](https://github.com/microsoft/BitNet) large language models. Uses CPU for inference. Includes [bitnet-b1.58-2B-4T](https://huggingface.co/microsoft/bitnet-b1.58-2B-4T-gguf) by default. Requires CPU with AVX2 support from Intel Haswell/AMD Excavator or later generations.

To run the built-in model conversationally:
```
podman run --rm ghcr.io/5310/oci-bitnet
```
To use your own arguments with the built-in model:
```
podman run --rm ghcr.io/5310/oci-bitnet <your arguments> -p "<your prompt>"
```
To use your own model, mount a volume from the host:
```
podman run --rm -it -v /some/host/path:/BitNet/models ghcr.io/5310/oci-bitnet --entrypoint sh
python3 run_inference.py -m models/<your model>.gguf <your arguments> -p "<your prompt>"
```
Check if your CPU supports AVX2 on Linux:
```
grep -o 'avx2' /proc/cpuinfo
```
