# Accord Parallel
Compilation is a pretty CPU intensive process, so it's much better to spread the load of compiling multiple files out accross multiple CPU cores. Accord Parallel does this by creating worker processes and sending compilation tasks to them.

Sadly, some compilers take functions and other complex datatypes as args. Those cannot be effectively sent between processes because sterilizing them into text would require sterilizing the entire scope along with it. So, when a complex datatype is passed, compilation will be done in the main thread.
