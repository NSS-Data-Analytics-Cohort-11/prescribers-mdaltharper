--1 A

select total_claim_count ,npi as prescriber_NPI
from prescription
order by total_claim_count desc
limit 1
--1B

select prescription.total_claim_count ,prescription.npi as prescriber_NPI,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
from prescription
	inner join prescriber
	using (npi)
order by prescription.total_claim_count desc
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



SELECT drug.generic_name, MAX(prescription.total_drug_cost) AS max_cost
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY drug.generic_name
ORDER BY max_cost DESC
limit 1

--3b
SELECT drug.generic_name, max(prescription.total_drug_cost / prescription.total_day_supply) AS highest_cost_per_day
FROM prescription
LEFT JOIN drug USING (drug_name)
GROUP BY drug.generic_name
order by max(prescription.total_drug_cost / prescription.total_day_supply) desc

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
    SUM(prescription.total_drug_cost) AS total_cost
FROM drug
left join prescription
using (drug_name)
GROUP BY drug_type 

--5







