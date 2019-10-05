#!/bin/bash
git checkout -b FIRST_TRY                  #crete a new local branch
git push origin FIRST_TRY                #synchronized with GitHub


while IFS='' read -r line || [[ -n "$line" ]]; do
cd /Users/romolodevito/Desktop/commons-lang
    git checkout $line
    git push origin $line:FIRST_TRY --force-with-lease
    echo "$line has been pushed to the github"
    #inizia la fase di ricerca delle dipendeze della classi modificate
    start=`date +%s`
    ./script.sh #script che crea un file dependsby.txt di class test, invocando lo script dependency_searching.py (cerca le dipendenze)
    end_selection=`date +%s`
    ./testing.sh dependsby.txt #script che va a testare le classi di test in dependsby.txt
    end=`date +%s`
    selection_time=$((end_selection-start))
    runtime=$((end-start))
    #echo "TIME - ${runtime}"
    echo Selection time was `expr $end_selection - $start` seconds.
    echo Execution time was `expr $end - $start` seconds.

    #vado a ricavare i dati relativi al testing
    python3 data_collection_new.py ${runtime} ${line} ${selection_time}

    #dopo aver testato e collezionato i dati relativi elimino il file di testo che sarà ricreato al prossimo commit
    rm -d "dependsby.txt"
    
    
    #sleep 5
done < "$1"
