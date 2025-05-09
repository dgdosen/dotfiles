select * from output_facts order by cumulative_feet;
select * from curve_composite_facts;
select * from curve_fragment_facts;
select * from curve_fragment_input_facts;
select * from curve_fragment_output_facts order by curve_fragment_fact_id, cumulative_feet;


select
curve_fragment_coefficient_facts.id,
curve_fragment_coefficient_facts.curve_fragment_fact_id,
curve_fragment_coefficient_facts.coefficient,
curve_fragment_coefficient_facts.coefficient_type,
curve_fragment_facts.curve_fragment_type, curve_composite_facts.turn_type, curve_composite_facts.start_fact_id
from curve_fragment_coefficient_facts, curve_fragment_facts, curve_composite_facts
where curve_fragment_coefficient_facts.curve_fragment_fact_id = curve_fragment_facts.id
and curve_fragment_facts.curve_composite_fact_id = curve_composite_facts.id;


select count(*) from output_facts;
