<?php

namespace DioLaminasTestIntegration\Db;

use DioLaminasTest\Db\OracleFixtureLoader;
use PHPUnit\Framework\TestListener;
use PHPUnit\Framework\TestListenerDefaultImplementation;
use PHPUnit\Framework\TestSuite;
use PHPUnit\Runner\TestHook;
use function getenv;
use function printf;

class IntegrationTestListener implements TestHook, TestListener
{
    use TestListenerDefaultImplementation;

    /** @var FixtureLoader[] */
    private $fixtureLoaders = [];

    public function startTestSuite(TestSuite $suite): void
    {
        if ($suite->getName() !== 'integration test') {
            return;
        }

        if (getenv('TESTS_DB_ORACLE_IS_ENABLED')) {
            // $this->fixtureLoaders[] = (new OracleFixtureLoader())->setFixturesDir(__DIR__ . '/fixtures/oracle');
        }

        if (empty($this->fixtureLoaders)) {
            return;
        }

        printf("\nIntegration test started.\n");

        foreach ($this->fixtureLoaders as $fixtureLoader) {
            $fixtureLoader->run();
        }
    }

    public function endTestSuite(TestSuite $suite): void
    {
        if (
            $suite->getName() !== 'integration test'
            || empty($this->fixtureLoader)
        ) {
            return;
        }

        printf("\nIntegration test ended.\n");

        foreach ($this->fixtureLoaders as $fixtureLoader) {
            $fixtureLoader->dropDatabase();
        }
    }
}
