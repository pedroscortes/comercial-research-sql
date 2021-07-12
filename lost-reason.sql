--in this query we look for and specific company and count the main lost reasons for a salesman
SELECT 
    pipedrive_deals.lost_reason,
    count(pipedrive_deals.lost_reason) as total
FROM
    pipedrive_deals
        INNER JOIN
    vendedores ON vendedores.ref_user_pipedrive = pipedrive_deals.user_id
    and vendedores.company_ref_id = pipedrive_deals.company_ref_id
		inner join pipedrive_stages on pipedrive_stages.stage_id = pipedrive_deals.stage_id
        and pipedrive_stages.company_ref_id = pipedrive_deals.company_ref_id
where 
	pipedrive_deals.status = "lost"
    and pipedrive_deals.company_ref_id = --insert id
    and vendedores.ref_user_pipedrive = --insert salesman id
    and pipedrive_stages.pipeline_id = 1
    group by pipedrive_deals.lost_reason
