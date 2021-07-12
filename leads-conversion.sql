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
        AND pipedrive_activities.salesfarm_ref_id = pipedrive_deals.salesfarm_ref_id
WHERE
    pipedrive_activities.done = 1
    and pipedrive_deals.salesfarm_ref_id = 1860
    and pipedrive_activities.marked_as_done_time between "2021-05-01 00:00:00" and "2021-05-31 23:59:59"
    group by pipedrive_deals.owner_name;