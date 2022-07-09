x86_64_asm_source := $(shell find src/impl/x86_64 -name *.asm)
x86_64_asm_objects := $(pathsubst src/impl/x86_64/%.asm, build/x86_64%.o, $(x86_64_asm_source))

$(x86_64_asm_objects): build/x86_64%.o, src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(pathsubst build/x86_64%.o, src/impl/x86_64/%.asm, $@) -o $@

.PHONY: build-x86_64
build-x86_64: $(x86_64_asm_objects)
	mkdir -p dist/x86_64 &&
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(x86_64_asm_objects) && \
	cp dist/x86_64/kernel.bin targets/x86_64/ido/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
