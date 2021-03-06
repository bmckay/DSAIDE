context("test-generate_ggplot.R")

test_that("generate_ggplot returns a ggplot",
          {
            simresult = simulate_SIR_model_ode()
            result = vector("list", 1)
            result[[1]]$dat = simresult$ts
            expect_is(generate_ggplot(result), "ggplot" )

            simresult = simulate_SEIRSd_model_stochastic()
            result = vector("list", 1)
            result[[1]]=simresult
            expect_is(generate_ggplot(result), "ggplot" )

            simresult = simulate_Complex_ID_Control_ode()
            result = vector("list", 1)
            result[[1]]=simresult
            expect_is(generate_ggplot(result), "ggplot" )

            simresult = simulate_multipathogen_ode()
            result = vector("list", 1)
            result[[1]]=simresult
            result[[1]]$title = "Hello"
            result[[1]]$legendlocation = "left"
            expect_is(generate_ggplot(result), "ggplot" )

            modelsettings =  list(modeltype = "_ode_", plotscale = 'y', nplots = 1)
            modelsettings$simfunction = 'simulate_idpatterns_ode'
            result = run_model(modelsettings)
            expect_is(generate_ggplot(result), "ggplot" )


          })

