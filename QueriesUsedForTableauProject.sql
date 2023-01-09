--USED IN TABLEAU PROJECT:

--1)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like 'India' 
Where continent is not null
--Group by date
Order by 1,2 


--2)

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeath
--Where location like 'India'
Where continent is null
and location NOT IN ('World', 'European Union', 'International')
Group by location
Order by 2 desc


--3)

Select location, population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeath
--Where location like 'India'
--Where continent is not null
Group by location, population
Order by 4 desc


--4)

Select location, population,date ,MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeath
--Where location like 'India'
--Where continent is not null
Group by location, population,date
Order by 4 desc
