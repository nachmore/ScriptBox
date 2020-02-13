Chrome has an annoying bug where it will sometimes hang on exit with a single thread at `CrashForExceptionInNonABICompliantCodeRange`. Unfortunately the process is unterminatable in this situation (you'll get an `Access Denied` no matter what you try).

A side effect of the zombie Chrome process is that it still holds a lock on the lockfile which prevents new isntances of Chrome from launching, forcing a reboot to clear the zombie process. One workaround is to close Chrome's handle to the lockfile - not ideal, but often better than a reboot.

You can do this via SysInternal's procexp64 (find chrome.exe -> Ctrl+H to show handles -> close handle to lockfile) or via handle64:

```
C:\bin>handle64 lockfile

Nthandle v4.22 - Handle viewer
Copyright (C) 1997-2019 Mark Russinovich
Sysinternals - www.sysinternals.com

chrome.exe         pid: 17000  type: File           7D8: C:\Users\you\AppData\Local\Google\Chrome Dev\User Data\lockfile
```

### Warning: At this point handle64 may also hang, leaving it as a zombie until you reboot...

```
C:\bin>handle64 -c 7d8 -y -p 17000

Nthandle v4.22 - Handle viewer
Copyright (C) 1997-2019 Mark Russinovich
Sysinternals - www.sysinternals.com

  7D8: File  (R--)   C:\Users\you\AppData\Local\Google\Chrome Dev\User Data\lockfile

Handle closed.
```

You can now open new instances of Chrome. Not great, not ideal, but often better than a reboot.
