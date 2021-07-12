SELECT 
    pipedrive_deals.pipedrive_id,
    pipedrive_deals.title,
    pipedrive_deals.add_time,
    inner_query.marked_as_done_time,
    datediff(inner_query.marked_as_done_time, pipedrive_deals.add_time) as diff
FROM
    pipedrive_deals
        INNER JOIN
    pipedrive_stages ON pipedrive_stages.stage_id = pipedrive_deals.stage_id
        AND pipedrive_stages.salesfarm_ref_id = pipedrive_deals.salesfarm_ref_id
        INNER JOIN
    (SELECT 
        MIN(pipedrive_activities.marked_as_done_time) AS marked_as_done_time,
            pipedrive_activities.deal_id,
            pipedrive_activities.salesfarm_ref_id
    FROM
        pipedrive_activities
    WHERE
        pipedrive_activities.salesfarm_ref_id = 1842
            AND marked_as_done_time IS NOT NULL
            and pipedrive_activities.deleted_at is null
    GROUP BY pipedrive_activities.deal_id) AS inner_query ON inner_query.deal_id = pipedrive_deals.pipedrive_id
        AND inner_query.salesfarm_ref_id = pipedrive_deals.salesfarm_ref_id
WHERE
    pipedrive_deals.salesfarm_ref_id = 1842
        AND pipedrive_stages.pipeline_id = 1
        AND pipedrive_deals.deleted_at IS NULL
GROUP BY pipedrive_deals.pipedrive_id;
