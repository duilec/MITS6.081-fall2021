# MITS6.081-fall2021

## introduce

This is my solution of lab in MITS6.081 fall2021. But `usertests` can't passes in lab **pgtbl**, because some old test from fall2020, you could ignore it or compete lab pgtbl in fall2020.

Thanks to the MIT professors for making this class public!

## how to use my solution of lab in local?

Firstly, you should clone my repository to **your local**

```bash
git clone https://github.com/duilec/MITS6.081-fall2021.git
```

Secondly, you should `git stash` branch of `main`, i.e. typed this command in terminal:

```bash
git stash
```

(PS: I don't know why the original MIT course didn't need to use the `git stash` command to temporarily store branch content)

Finally, you should switch branch **by determining your need** in local.
example(switch to util):

```bash
git fetch
git checkout util
make clean
```

Note: 

- **I create a `main` to save `README.md` that you could ignore it**

- Class support 10 labs and I add a `main`, so we has 11 branch

  ```bash
  cow
  fs
  lock
  main
  mmap
  net
  pgtbl
  syscall
  thread
  traps
  util
  ```

  

## course introduce

Catalog description: Design and implementation of operating systems, and their use as a foundation for systems programming. Topics include virtual memory; file systems; threads; context switches; kernels; interrupts; system calls; interprocess communication; coordination, and interaction between software and hardware. A multi-processor operating system for RISC-V, xv6, is used to illustrate these topics. Individual laboratory assignments involve extending the xv6 operating system, for example to support sophisticated virtual memory features and networking.

You may wonder why we are studying xv6, an operating system that resembles Unix v6, instead of the latest and greatest version of Linux, Windows, or BSD Unix. xv6 is big enough to illustrate the basic design and implementation ideas in operating systems. On the other hand, xv6 is far smaller than any modern production O/S, and correspondingly easier to understand. xv6 has a structure similar to many modern operating systems; once you've explored xv6 you will find that much is familiar inside kernels such as Linux.

FROM: [6.S081: Learning by doing](https://pdos.csail.mit.edu/6.S081/2020/overview.html)

## course website

- [MITS6.081 fall2021](https://pdos.csail.mit.edu/6.S081/2021/)
- [MITS6.081 fall2020](https://pdos.csail.mit.edu/6.S081/2020/)

## useful link

- lecture video[fall2020]

  - [youtube](https://www.youtube.com/watch?v=J3LCzufEYt0&list=PLTsf9UeqkReZHXWY9yJvTwLJWYYPcKEqK) 
  - [bilibili](https://www.bilibili.com/video/BV19k4y1C7kA?from=search&seid=5542820295808098475)
- [The xv6 Kernel analysis](https://www.youtube.com/watch?v=fWUJKH0RNFE&list=PLbtzT1TYeoMhTPzyTZboW_j7TPAnjv9XB) FROM [hhp3](https://www.youtube.com/user/hhp3)
- [book-riscv-rev2](https://pdos.csail.mit.edu/6.828/2021/xv6/book-riscv-rev2.pdf), [book-riscv-rev1](https://pdos.csail.mit.edu/6.828/2020/xv6/book-riscv-rev1.pdf)
- [MITS6.081 fall2020 课程视频中文翻译](https://mit-public-courses-cn-translatio.gitbook.io/mit6-s081/)
- [book-riscv-rev1 中文翻译](http://xv6.dgs.zone/tranlate_books/book-riscv-rev1/summary.html)
- [实验内容中文翻译](http://xv6.dgs.zone/labs/requirements/summary.html)
- 我用中文写了全部个人解析，放在个人博客和博客园中。
  - [memory dot/MIT6.S081-Lab](https://duilec.github.io/categories/MIT6-S081-Lab/)，[duile/MIT6.S081-Lab](https://www.cnblogs.com/duile/tag/MIT6.S081-Lab/)
