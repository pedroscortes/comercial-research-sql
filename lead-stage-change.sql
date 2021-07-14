SELECT 
    pipedrive_deals.pipedrive_id,
    pipedrive_deals.title,
    pipedrive_deals.status,
    pipedrive_deals.owner_name,
    pipedrive_deals.stage_id,
    pipedrive_deals.add_time,
    pipedrive_times_in_stages.data_entrada
FROM
    pipedrive_times_in_stages
        INNER JOIN
    pipedrive_stages ON pipedrive_stages.stage_id = pipedrive_times_in_stages.stage
        AND pipedrive_stages.company_ref_id = pipedrive_times_in_stages.company_ref_id
        INNER JOIN
    pipedrive_deals ON pipedrive_deals.pipedrive_id = pipedrive_times_in_stages.deal_id
        AND pipedrive_deals.company_ref_id = pipedrive_times_in_stages.company_ref_id
        AND pipedrive_deals.deleted_at IS NULL
        where pipedrive_times_in_stages.company_ref_id = -- insert id
        and pipedrive_times_in_stages.data_entrada is not null
        and pipedrive_times_in_stages.data_entrada between -- insert date range
	and pipedrive_times_in_stages.stage = -- insert stage
        group by pipedrive_deals.pipedrive_id;