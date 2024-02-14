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

3b---

