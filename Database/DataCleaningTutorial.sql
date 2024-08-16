-- create dummy table for working purpose

create table layoffs_work
like layoffs;

Insert into layoffs_work
select *
from layoffs;



with cte_row_num as
(
select *, row_number() over
(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as `row_count`
from layoffs_work
)
select *
from cte_row_num
where `row_count`>1;


-- checking a random duplicate to make sure

select *
from layoffs_work
where company like "casper%";

-- performing cte and creating another dummy table with row count column in it
-- to delete duplicated rows

CREATE TABLE `layoffs_work2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_count` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs_work2;

insert into layoffs_work2
select *, row_number() over
(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as `row_count`
from layoffs_work;



-- trimming company name


select company, Trim(company)
from layoffs_work2;

update layoffs_work2
set company = Trim(company);


-- setting up Crypto Currency to all crypto related industry 


select *
from layoffs_work2
where industry like "Crypto%";

update layoffs_work2
set industry = "Crypto Currency"
where industry like "Crypto%";


-- standardizing location

select Distinct location
from layoffs_work2
order by 1;


select *
from layoffs_work2
where location like 'DÃ¼sseldorf';


update layoffs_work2
set location = "Düsseldorf"
where location like "DÃ¼sseldorf";



select *
from layoffs_work2
where location like 'FlorianÃ³polis';


update layoffs_work2
set location = 'Florianópolis'
where location like 'FlorianÃ³polis';



select Distinct country
from layoffs_work2
order by 1;

select *
from layoffs_work2
where country = 'United States.';


update layoffs_work2
set country = "United States"
where country = 'United States.';


-- Standardizing Dates

select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_work2;

update layoffs_work2
set `date` = str_to_date(`date`, '%m/%d/%Y');


alter table layoffs_work2
modify column `date` date;


select *
from layoffs_work2
where industry is null or industry = '';

-- Filling null and blank spaces

select *
from layoffs_work2
where company = 'Airbnb';


update layoffs_work2
set industry = 'Travel'
where company = 'Airbnb';


select *
from layoffs_work2
where company = 'Carvana';


update layoffs_work2
set industry = 'Transportation'
where company = 'Carvana';


select *
from layoffs_work2
where company = 'Juul';

update layoffs_work2
set industry = 'Consumer'
where company = 'Juul';



select *
from layoffs_work2 t1
join layoffs_work2 t2
	using (company)
where t1.industry = "" or t1.industry is null;

-- removing irrelevant columns

alter table layoffs_work2
drop column `row_count`;


select *
from layoffs_work2















