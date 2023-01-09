/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


Select *
From PortfolioProject..CovidDeath
Where continent is not null 
Order by 3,4


--Select the data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeath
Where continent is not null 
Order by 1,2


--Showing total_cases vs total_deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeath
Where location like 'India' and continent is not null
Order by 1,2 


--Showing total_cases vs population
--Shows percentage of people who got covid

Select location, date, population, total_cases, (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeath
Where location like 'India' 
Order by 1,2 


--Showing countries highest infected count

Select location, population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeath
--Where location like 'India'
Group by location, population
Order by 4 desc


--Showing countries with Highest death count

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeath
--Where location like 'India'
Where continent is not null
Group by location
Order by 2 desc


--LET'S BREAK THINGS DOWN BY CONTINENT
--Showing continents with highest death count

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeath
--Where location like 'India'
Where continent is not null
Group by continent
Order by 2 desc


--GLOBAL NO.'S

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like 'India' 
Where continent is not null
--Group by date
Order by 1,2 


--Showing total population vs total vaccinations

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert( bigint, ISNULL( v.new_vaccinations,0))) OVER (Partition by d.location Order by  d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath d
Join PortfolioProject..CovidVacci v
On d.location=v.location
and d.date=v.date
Where d.continent is not null
Order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopVsVac( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert( bigint, ISNULL( v.new_vaccinations,0))) OVER (Partition by d.location Order by  d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath d
Join PortfolioProject..CovidVacci v
On d.location=v.location
and d.date=v.date
Where d.continent is not null
--Order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100 
From PopVsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

Drop table if exists #PopPercentageVaccinated
Create table #PopPercentageVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PopPercentageVaccinated

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert( bigint, ISNULL( v.new_vaccinations,0))) OVER (Partition by d.location Order by  d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath d
Join PortfolioProject..CovidVacci v
On d.location=v.location
and d.date=v.date
--Where d.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 
From #PopPercentageVaccinated


--Creating view to store data for later visualizations
Drop view PopPercentageVaccinated

USE PortfolioProject
GO

Create View  PopPercentageVaccinated as

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert( bigint, ISNULL( v.new_vaccinations,0))) OVER (Partition by d.location Order by  d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath d
Join PortfolioProject..CovidVacci v
On d.location=v.location
and d.date=v.date
Where d.continent is not null
--Order by 2,3




