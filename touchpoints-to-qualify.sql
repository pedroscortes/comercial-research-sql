SELECT 
    pipedrive_deals.pipedrive_id,
    (
        SELECT 
            SUM(1)
        FROM
            pipedrive_activities as pipedrive_activities_sub
        INNER JOIN
            `activity_types` ON pipedrive_activities_sub.`type` = `activity_types`.`key_string`
            AND pipedrive_activities_sub.`company_ref_id` = `activity_types`.`company_ref_id`
            AND `activity_types`.`icon_key` NOT IN ('loop' , 'finish')
        WHERE
            pipedrive_activities_sub.deal_id = pipedrive_deals.pipedrive_id
                AND pipedrive_activities_sub.company_ref_id = pipedrive_deals.company_ref_id
                AND pipedrive_activities_sub.`deleted_at` IS NULL 
                AND pipedrive_activities_sub.marked_as_done_time BETWEEN pipedrive_deals.add_time AND atividade_deal.marked_as_done_time
                AND pipedrive_activities_sub.done=1
    ) AS qtd_atividades,
        DATE_FORMAT(
        (
            CONVERT_TZ(pipedrive_deals.add_time,
            '+00:00',
            '-03:00') 
        ),'%d/%m/%Y') as data_deal_criada,
        DATE_FORMAT(
            CONVERT_TZ(atividade_deal.marked_as_done_time,
            '+00:00',
            '-03:00'),'%d/%m/%Y')
            as data_atividade_concluida
FROM
    `pipedrive_deals`
        INNER JOIN
    `pipedrive_activities` as atividade_deal ON `pipedrive_deals`.`pipedrive_id` = atividade_deal.`deal_id`
        AND `pipedrive_deals`.`company_ref_id` = atividade_deal.`company_ref_id`
        AND atividade_deal.`done` = 1
        AND CONVERT_TZ(atividade_deal.marked_as_done_time,
            '+00:00',
            '-03:00') BETWEEN -- insert date range
        AND atividade_deal.`deleted_at` IS NULL
        INNER JOIN
    `activity_types` ON atividade_deal.`type` = `activity_types`.`key_string`
        AND atividade_deal.`company_ref_id` = `activity_types`.`company_ref_id`
        AND `activity_types`.`icon_key` IN ('loop' , 'finish')
WHERE
    `pipedrive_deals`.`company_ref_id` = -- insert company id
        AND `pipedrive_deals`.`deleted_at` IS NULL
GROUP BY pipedrive_deals.pipedrive_id