# =========================================================
# Root-Finding Methods Interactive Menu in R
# (Bisection, Newton-Raphson, Successive Approximation)
# Shows iteration tables and allows multiple runs
# =========================================================

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
library(dplyr)

# ----------------- Methods -----------------

# Bisection Method
bisection_method <- function(f, a, b, tol = 1e-6, max_iter = 100) {
  if (f(a) * f(b) >= 0) stop("f(a) and f(b) must have opposite signs.")
  
  results <- data.frame(Iteration = integer(),
                        a = numeric(),
                        b = numeric(),
                        c = numeric(),
                        f_c = numeric(),
                        Error = numeric())
  
  for (i in 1:max_iter) {
    c <- (a + b) / 2
    error <- abs(b - a) / 2
    results <- rbind(results, data.frame(Iteration = i, a, b, c, f_c = f(c), Error = error))
    
    if (abs(f(c)) < tol || error < tol) {
      cat("\n✅ Converged in", i, "iterations\n")
      print(results)
      return(c)
    }
    
    if (f(a) * f(c) < 0) {
      b <- c
    } else {
      a <- c
    }
  }
  cat("\n⚠️ Max iterations reached.\n")
  print(results)
  return(c)
}

# Newton-Raphson Method
newton_raphson <- function(f, f_prime, x0, tol = 1e-6, max_iter = 100) {
  x <- x0
  results <- data.frame(Iteration = integer(),
                        x = numeric(),
                        f_x = numeric(),
                        Error = numeric())
  
  for (i in 1:max_iter) {
    fx <- f(x)
    fpx <- f_prime(x)
    if (fpx == 0) stop("Derivative became zero!")
    
    x_new <- x - fx / fpx
    error <- abs(x_new - x)
    results <- rbind(results, data.frame(Iteration = i, x, f_x = fx, Error = error))
    
    if (error < tol) {
      cat("\n✅ Converged in", i, "iterations\n")
      print(results)
      return(x_new)
    }
    x <- x_new
  }
  cat("\n⚠️ Max iterations reached.\n")
  print(results)
  return(x)
}

# Successive Approximation (Fixed-Point Iteration)
successive_approx <- function(g, x0, tol = 1e-6, max_iter = 100) {
  x <- x0
  results <- data.frame(Iteration = integer(),
                        x = numeric(),
                        g_x = numeric(),
                        Error = numeric())
  
  for (i in 1:max_iter) {
    x_new <- g(x)
    error <- abs(x_new - x)
    results <- rbind(results, data.frame(Iteration = i, x, g_x = x_new, Error = error))
    
    if (error < tol) {
      cat("\n✅ Converged in", i, "iterations\n")
      print(results)
      return(x_new)
    }
    x <- x_new
  }
  cat("\n⚠️ Max iterations reached.\n")
  print(results)
  return(x)
}

# ----------------- Interactive Menu -----------------

repeat {
  cat("\n==============================\n")
  cat("🔹 ROOT FINDING MENU\n")
  cat("==============================\n")
  cat("1. Bisection Method\n")
  cat("2. Newton-Raphson Method\n")
  cat("3. Successive Approximation Method\n")
  cat("4. Exit\n")
  
  choice <- as.integer(readline(prompt = "Enter your choice (1-4): "))
  
  if (choice == 1) {
    cat("\n--- 🧮 Bisection Method ---\n")
    func_str <- readline(prompt = "Enter function f(x) (e.g., x^3 - x - 2): ")
    f <- function(x) eval(parse(text = func_str))
    a <- as.numeric(readline(prompt = "Enter lower limit a: "))
    b <- as.numeric(readline(prompt = "Enter upper limit b: "))
    root <- bisection_method(f, a, b)
    cat("\nApproximate root:", root, "\n")
    
  } else if (choice == 2) {
    cat("\n--- 🧮 Newton-Raphson Method ---\n")
    func_str <- readline(prompt = "Enter function f(x): ")
    deriv_str <- readline(prompt = "Enter derivative f'(x): ")
    f <- function(x) eval(parse(text = func_str))
    f_prime <- function(x) eval(parse(text = deriv_str))
    x0 <- as.numeric(readline(prompt = "Enter initial guess x0: "))
    root <- newton_raphson(f, f_prime, x0)
    cat("\nApproximate root:", root, "\n")
    
  } else if (choice == 3) {
    cat("\n--- 🧮 Successive Approximation Method ---\n")
    g_str <- readline(prompt = "Enter function g(x) (e.g., sqrt(2*x + 3)): ")
    g <- function(x) eval(parse(text = g_str))
    x0 <- as.numeric(readline(prompt = "Enter initial guess x0: "))
    root <- successive_approx(g, x0)
    cat("\nApproximate root:", root, "\n")
    
  } else if (choice == 4) {
    cat("\n👋 Exiting program. Goodbye!\n")
    break
    
  } else {
    cat("\n⚠️ Invalid choice. Please enter a number between 1 and 4.\n")
  }
}
