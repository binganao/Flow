echo "Scan task start"
echo "Scan task start" | notify -silent


echo "Updating vuln repository"
echo "Updating vuln repository" | notify -silent
nuclei -silent -update > /dev/null
nuclei -silent -ut > /dev/null
echo "Update vuln repository complete"
echo "Update vuln repository complete" | notify -silent


echo "The first step of collecting subdomain names is in progress"
echo "The first step of collecting subdomain names is in progress" | notify -silent
subfinder -silent -dL domains.txt -o subfinder.txt.tmp
cat subfinder.txt.tmp | anew subdomain-all.txt
rm -f subfinder.txt.tmp
echo "The first step of collecting subdomains is completed"
echo "The first step of collecting subdomains is completed" | notify -silent

# 暂停使用: ksubdomain 存在巨大问题，爆破子域名时不考虑通配符
# echo "The second step of collecting subdomain names is in progress"
# echo "The second step of collecting subdomain names is in progress" | notify -silent
# ksubdomain enum -dl domains.txt -f /script/dict/sub-dict.txt -l 3 --silent --skip-wild --only-domain -o ksubdomain.txt.tmp
# cat ksubdomain.txt.tmp | anew subdomain-all.txt
# rm -f ksubdomain.txt.tmp
# echo "The second step of collecting subdomains is completed"
# echo "The second step of collecting subdomains is completed" | notify -silent


echo "From targets.txt add target"
echo "From targets.txt add target" | notify -silent
cat targets.txt | anew subdomain-all.txt
echo "From targets.txt add target complete"
echo "From targets.txt add target complete" | notify -silent


echo "Filtering duplicate domain names in new assets"
echo "Filtering duplicate domain names in new assets" | notify -silent
cat subdomain-all.txt | anew all.txt > newdomains.txt
rm -f subdomain-all.txt
sort -u newdomains.txt > temp.txt && cat temp.txt > newdomains.txt
rm -f temp.txt
echo "Filter duplicate domain names in new assets completed"
echo "Filter duplicate domain names in new assets completed, Result: $(wc -l < newdomains.txt| awk '{print $0}')" | notify -silent


echo "Gathering surviving ports [TOP 100] from nmap"
echo "Gathering surviving ports [TOP 100] from nmap" | notify -silent
if [ -f naabu.txt ] ; then
    rm -f naabu.txt
fi
naabu -stats -l newdomains.txt -top-ports 100 -silent -o naabu.txt
echo "Gather surviving ports complete"
echo "Gather surviving ports complete, Result: $(wc -l < naabu.txt| awk '{print $0}')" | notify -silent


echo "Getting HTTP service"
echo "Getting HTTP service" | notify -silent
if [ -f httpx.txt ] ; then
    rm -f httpx.txt
fi
httpx -silent -stats -l naabu.txt -fl 0 -mc 200,302,403,404,204,303,400,401 -o httpx.txt
echo "Get HTTP service complete"
echo "Get HTTP service complete, Result: $(wc -l < httpx.txt| awk '{print $0}')" | notify -silent


echo "The first step of scanning for vulnerabilities is in progress"
echo "The first step of scanning for vulnerabilities is in progress" | notify -silent
cat httpx.txt | nuclei -o nuclei-results.txt.tmp -timeout 5 -stats -silent -rl 300 -bs 35 -mhe 15 -c 500 -severity critical,medium,high,low | notify -silent
if [ ! -d "nuclei-results" ]; then
    mkdir nuclei-results
fi
nuclei_filename=$(date +%F-%T)
cat nuclei-results.txt.tmp | anew nuclei-results/${nuclei_filename}.txt
rm -f nuclei-results.txt.tmp
echo "The first step of scanning vulnerabilities is completed"
echo "The first step of scanning vulnerabilities is completed, Result: ${nuclei_filename}.txt $(wc -l < nuclei-results/${nuclei_filename}.txt| awk '{print $0}')" | notify -silent


echo "The second step of scanning for vulnerabilities is in progress"
echo "The second step of scanning for vulnerabilities is in progress" | notify -silent
if [ ! -d "xray-results" ]; then
    mkdir xray-results
fi
xray_filename=$(date +%F-%T)
xray webscan  --url-file httpx.txt --html-output xray-results/${xray_filename}.html
echo "The second step of scanning vulnerabilities is completed"
echo "The second step of scanning vulnerabilities is completed, Result: ${xray_filename}.html $(wc -l < xray-results/${xray_filename}.html| awk '{print $0}')" | notify -silent

# xscan 自行安装
# echo "The third step of scanning for vulnerabilities is in progress"
# echo "The third step of scanning for vulnerabilities is in progress" | notify -silent
# xscan -file httpx.txt -auto-white
# if [ ! -d "xscan-results" ]; then
#     mkdir xscan-results
# fi
# xscan_filename=$(date +%F-%T)
# cp result.json xscan-results/${xscan_filename}.json
# rm -f result.json
# echo "The third step of scanning vulnerabilities is completed"
# echo "The third step of scanning vulnerabilities is completed, Result: ${xscan_filename}.json $(wc -l < xscan-results/${xscan_filename}.json| awk '{print $0}')" | notify -silent

echo "The scanning task has been completed"
echo "The scanning task has been completed" | notify -silent