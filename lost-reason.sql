SELECT 
    pipedrive_deals.lost_reason,
    count(pipedrive_deals.lost_reason) as total
FROM
    pipedrive_deals
        INNER JOIN
    vendedores ON vendedores.ref_user_pipedrive = pipedrive_deals.user_id
    and vendedores.salesfarm_ref_id = pipedrive_deals.salesfarm_ref_id
		inner join pipedrive_stages on pipedrive_stages.stage_id = pipedrive_deals.stage_id
        and pipedrive_stages.salesfarm_ref_id = pipedrive_deals.salesfarm_ref_id
where 
	pipedrive_deals.status = "lost"
    and pipedrive_deals.salesfarm_ref_id = 1860
    and vendedores.ref_user_pipedrive = 11814605
    and pipedrive_stages.pipeline_id = 1
    group by pipedrive_deals.lost_reason