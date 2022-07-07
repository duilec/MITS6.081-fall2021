#define O_RDONLY  0x000 // only read
#define O_WRONLY  0x001 // only write
#define O_RDWR    0x002 // read and write
#define O_CREATE  0x200 // if not exsit, create a file, else do nothing? or just create a file?
#define O_TRUNC   0x400 // truncate length to 0
#define O_NOFOLLOW  0x020 // you should open symlink but not open itself
