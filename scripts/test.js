const server = "http://localhost:3000";

document.getElementById("end-proposal").addEventListener('click', () => {

  fetch(`${server}/optimizeFundWeights`).then((response) => {
    return response.json();
  }).then((data) => {
    console.log(data);
  });
});
