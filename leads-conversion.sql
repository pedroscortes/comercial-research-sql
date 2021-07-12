--we built this query to dimension the conversion of the sdr's individually so we can look deeply for possible outliers
--at the selection we use a simple binary logic simmilar to what we usually do in python to count leads with different status
--we use group by in the owner_name column so we can make sure that we are dimensioning the conversions individually
SELECT 
    pipedrive_deals.owner_name,
    round(sum(case
		when pipedrive_deals.status = "lost" then 1 else 0
        end)/(COUNT(pipedrive_deals.owner_name))*100,2) as lost,
	round(sum(case
		when pipedrive_deals.status = "open" then 1 else 0
        end)/(COUNT(pipedrive_deals.owner_name))*100,2) as open,
	round(sum(case
		when pipedrive_deals.status = "won" then 1 else 0
        end)/(COUNT(pipedrive_deals.owner_name))*100,2) as won
FROM
    pipedrive_deals
        INNER JOIN
    pipedrive_activities ON pipedrive_activities.deal_id = pipedrive_deals.pipedrive_id
        AND pipedrive_activities.salesfarm_ref_id = pipedrive_deals.company_ref_id
WHERE
    pipedrive_activities.done = 1
    and pipedrive_deals.company_ref_id = --insert id
    and pipedrive_activities.marked_as_done_time between --insert date range
    group by pipedrive_deals.owner_name;
