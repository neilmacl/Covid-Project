
-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM Covid..CovidDeaths
ORDER BY 1, 2

-- Total Cases vs Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS total_cases_percentage
FROM Covid..CovidDeaths
ORDER BY 1, 2

-- Infection rate
SELECT location, population, MAX(total_cases) AS max_infection_count, MAX((total_cases/population))*100 AS max_infection_rate
FROM Covid..CovidDeaths
GROUP BY location, population
ORDER BY max_infection_rate DESC

-- Highest Death Count per Capita
SELECT location, population, MAX(cast(total_deaths AS float)) AS total_death_count, MAX((cast(total_deaths AS float)/population))*100 AS total_death_rate
FROM Covid..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY total_death_rate DESC

--Highest Death Count
SELECT Location, MAX(cast(total_deaths AS float)) AS total_death_count
FROM Covid..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC

-- Death Count by Continent
SELECT location, MAX(cast(total_deaths AS float)) AS total_death_count
FROM Covid..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY total_death_count DESC

-- Global Numbers

-- Total Global Death Rate
SELECT SUM(new_cases) AS global_cases, SUM(cast(new_deaths AS int)) AS global_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS global_death_percentage
FROM Covid..CovidDeaths
WHERE continent is not null

--Joining Table
SELECT *
FROM Covid..CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--Total population vs Vaccination
SELECT dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--Total population vs Vaccination Rolling Count CTE
WITH popvsvac (continent, location, population, date, new_vaccinations, rolling_vaccination_count) 
AS
(
SELECT dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER by dea.location, dea.date) AS rolling_vaccination_count
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (rolling_vaccination_count/population)*100 AS rolling_vaccination_percentage
FROM popvsvac
ORDER BY population DESC

--Creating View to Store Data for Visulizations
Create View popvsvac AS
SELECT dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER by dea.location, dea.date) AS rolling_vaccination_count
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

Create View DeathPerCapita AS
SELECT location, population, MAX(cast(total_deaths AS float)) AS total_death_count, MAX((cast(total_deaths AS float)/population))*100 AS total_death_rate
FROM Covid..CovidDeaths
WHERE continent is not null
GROUP BY location, population


CREATE VIEW DeathPercentage AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM Covid..CovidDeaths


CREATE VIEW TotalCasesPercentage AS
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS total_cases_percentage
FROM Covid..CovidDeaths
-- FOR TABLEAY VISULIZATION

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM Covid..CovidDeaths
WHERE continent is not null

SELECT Location, SUM(CAST(new_deaths as int)) as TotalDeaths
FROM Covid..CovidDeaths
WHERE continent is null
AND location not in ('World', 'European Union', 'International') 
Group by location
Order by TotalDeaths DESC

SELECT Location, Population, MAX(total_cases) AS TotalInfections, MAX(total_cases/population)*100 AS PercentInfected
FROM Covid..CovidDeaths
Group by Location, Population
Order by PercentInfected DESC

SELECT Location, Population, Date, MAX(total_cases) AS TotalInfections, MAX(total_cases/population)*100 AS PercentInfected
FROM Covid..CovidDeaths
Group by Location, Population, Date
Order by PercentInfected Desc, Date DESC 

