set HOME=C:\Users\joeki
del /Q "%HOM%/.emacs.d/server/*"
runemacs.exe --daemon

emacsclientw.exe -n -c --alternate-editor="runemacs.exe"
