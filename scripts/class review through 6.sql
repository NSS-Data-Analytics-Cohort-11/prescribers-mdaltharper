--1 A

select npi,
	sum(total_claim_count) as total_claims 
from prescription
group by npi
order by total_claims desc
limit 1
--1B

select sum(prescription.total_claim_count) as total_claims ,prescriber.npi as prescriber_NPI,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
from prescription
	inner join prescriber
	using (npi)
group by prescriber.nppes_provider_first_name,
prescriber.nppes_provider_last_org_name,
prescriber.specialty_description,
prescriber.npi
order by total_claims desc
limit 1

--2a
select prescriber.specialty_description,sum(prescription.total_claim_count)
from prescription 
	inner join prescriber
	using (npi)
group by prescriber.specialty_description
order by sum(prescription.total_claim_count) desc
limit 1

--2b

select prescriber.specialty_description,sum(prescription.total_claim_count) AS opioid_total_claims
from prescription 
	inner join prescriber
	using (npi)
	inner join drug on drug.drug_name = prescription.drug_name
where drug.opioid_drug_flag = 'Y'
group by prescriber.specialty_description
order by sum(prescription.total_claim_count) desc
limit 1

--3a



SELECT drug.generic_name,sum(prescription.total_drug_cost) AS max_cost
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY drug.generic_name
ORDER BY max_cost DESC
limit 1

--3b
SELECT drug.generic_name, sum(prescription.total_drug_cost) / sum(prescription.total_day_supply) AS highest_cost_per_day
FROM prescription
LEFT JOIN drug USING (drug_name)
GROUP BY drug.generic_name
order by highest_cost_per_day desc

--4a

select 
drug_name,
case
	when opioid_drug_flag = 'Y' THEN 'opioid'
	when antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	else 'neither'
end as drug_type
from drug;

--4b

SELECT
    CASE
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type,
    SUM(prescription.total_drug_cost)::money AS total_cost
FROM drug
left join prescription
using (drug_name)
GROUP BY drug_type 

--5a
select count (*)
from cbsa
inner join fips_county
using (fipscounty)
where state = 'TN'
--OR
select distinct (cbsa) ,cbsaname
from cbsa
WHERE cbsaname like '%TN%'

--5b



SELECT cbsa.cbsaname AS CBSA_Name,
      SUM(population.population) AS total_population
       FROM cbsa
INNER JOIN fips_county ON cbsa.fipscounty = fips_county.fipscounty
INNER JOIN population ON cbsa.fipscounty = population.fipscounty
where fips_county.state = 'TN'
GROUP BY cbsa.cbsaname
ORDER BY total_population DESC

--5c


SELECT
    cbsa.cbsaname,
    fips_county.county,
	MAX(population.population) AS Largest_Population
FROM fips_county
LEFT JOIN cbsa ON fips_county.fipscounty = cbsa.fipscounty
LEFT JOIN population ON fips_county.fipscounty = population.fipscounty
WHERE population.population IS NOT NULL and cbsa.cbsaname is null
GROUP BY cbsa.cbsaname ,  fips_county.county
ORDER BY Largest_Population DESC;

--6a

select drug_name ,total_claim_count
from prescription
where total_claim_count >= 3000

--6b
SELECT
    drug.drug_name,
    prescription.total_claim_count,
    CASE
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        ELSE 'not opioid'
    END AS drug_type
FROM drug
INNER JOIN prescription USING (drug_name)
WHERE prescription.total_claim_count >= 3000;



---6c

SELECT
    drug.drug_name,
    prescription.total_claim_count,
    prescriber.nppes_provider_last_org_name,
    prescriber.nppes_provider_first_name,
    CASE
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        ELSE 'not opioid'
    END AS drug_type
FROM drug
INNER JOIN prescription USING (drug_name)
INNER JOIN prescriber ON prescriber.npi = prescription.npi
WHERE prescription.total_claim_count >= 3000;

--7a


  
  SELECT
    prescriber.npi,
    drug.drug_name
FROM prescriber
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
  AND prescriber.nppes_provider_city = 'NASHVILLE'
  AND drug.opioid_drug_flag = 'Y';

--7b

SELECT
    prescriber.npi,
    drug.drug_name,
    COUNT(prescription.total_claim_count) AS total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription ON prescriber.npi = prescription.npi AND drug.drug_name = prescription.drug_name
GROUP BY prescriber.npi, drug.drug_name;

--7c
SELECT
    prescriber.npi,
    drug.drug_name,
    COALESCE(SUM(prescription.total_claim_count), 0) AS total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription ON prescriber.npi = prescription.npi AND drug.drug_name = prescription.drug_name
GROUP BY prescriber.npi, drug.drug_name;



