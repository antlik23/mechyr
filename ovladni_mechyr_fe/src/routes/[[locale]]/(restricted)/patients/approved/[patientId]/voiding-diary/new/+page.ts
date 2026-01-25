export async function load({ params }) {
  const patientId = Number(params.patientId);

  return {
    pageParams: {
      ...params,
      patientId,
    },
  };
}
