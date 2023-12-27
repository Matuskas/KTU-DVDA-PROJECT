### Projekto aprašymas
Projekto tikslas buvo sukurti duomenų produktą - analitinę aplikaciją, skirtą banko paskolos įvertinimui mašininio mokymosi algoritmų pagalba. 


### Projektą sudaro 6 aplankai:
- "1-data" - Duomenų failų aplankalas, tačiau čia įkelti neleido, kadangi GitHub failo įkėlimo dydis negali viršyti 25MB.
- "2-report" - Šiame aplankale yra failas, kuriame aprašyta žvalgomoji duomenų analizė.
- "3-R" - Šiame aplankale yra du R programavimo kalbos failai, kuriuose yra atliekami duomenų tvarkymo darbai, bei modeliavimas.
- "4-model" - Šiame aplankale yra patalpintas modelis, kuris tenkina minimalias užduoties sąlygas(AUC > 0.8);
            Modelis buvo sugeneruotas su GBM metodu. AUC kreivė po testavimo imtimi = 0.829.
- "5-predictions" - Šiame aplankale yra du csv failai, kurie reprezentuoja prognozuojamas tikimybes prie kurios klasės bus priskirtas įrašas. 
                  "predictions1.csv" buvo atliktas su persimokiusiu GBM modeliu;
                  "predictions3.csv" buvo sugeneruotas su tuo GBM modeliu, kuris patalpintas "4-model" aplankale.
- "app" - Šiame aplankale yra Shiny WEB aplikacija, kuri leidžia banko darbuotojui įvesti duomenis apie klientą ir su sukurtu modeliu prognozuoti ar paskolą verta duoti ar ne.
