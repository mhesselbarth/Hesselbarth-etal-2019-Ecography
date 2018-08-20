.ls.objects <- function (pos = 1, pattern, order.by,
                         decreasing=FALSE, head=FALSE, n=5) {
  napply <- function(names, fn) sapply(names, function(x)
    fn(get(x, pos = pos)))
  names <- ls(pos = pos, pattern = pattern)
  obj.class <- napply(names, function(x) as.character(class(x))[1])
  obj.mode <- napply(names, mode)
  obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
  obj.prettysize <- napply(names, function(x) {
    format(utils::object.size(x), units = "auto") })
  # obj.size <- napply(names, object.size)
  # obj.dim <- t(napply(names, function(x)
  #   as.numeric(dim(x))[1:2]))
  # vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
  # obj.dim[vec, 1] <- napply(names, length)[vec]
  # out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
  out <- data.frame(obj.type, obj.prettysize)
  
  names(out) <- c("Type", "PrettySize")
  # names(out) <- c("Type", "Size", "PrettySize", "Length/Rows", "Columns")
  
  if (!missing(order.by))
    out <- out[order(out[[order.by]], decreasing=decreasing), ]
  if (head)
    out <- head(out, n)
  out
}

# shorthand
lsos <- function(..., n=10) {
  .ls.objects(..., order.by="PrettySize", decreasing = TRUE, head=TRUE, n=n)
}

lsos()

ls_sizes <- function(envir, n = 10, decreasing = TRUE) {
  
  if(missing(envir)) {
    envir <- .GlobalEnv
  }
  
  objects <- ls(envir = envir)
  
  size_objects <- purrr::map_dfr(objects, function(x){
    
    tibble::tibble(name = x,
                   class = mode(get(x, envir = envir)), 
                   size = as.double(object.size(get(x, envir = envir))),
                   size_formatted = format(utils::object.size(get(x, envir = envir)),
                                           units = "auto"))
  })
  
  size_objects <- dplyr::filter(size_objects, class != "function")
  
  
  if(isTRUE(decreasing)) {
    size_objects <- dplyr::arrange(size_objects, desc(size))
  }
  
  else {
    size_objects <- dplyr::arrange(size_objects, size)
  }
  
  size_objects <- head(size_objects, n = n)
  
  
  return(size_objects)
}