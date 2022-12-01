// https://gist.github.com/joss-aztec/27cbe3f772ae1b421f7edef2b7e5a9bb
// https://gist.github.com/joss-aztec/5b346e82312e5c3a4b9cb1c109295ddf
// User Circuit
use dep::std;

global CANDIDATE_COUNT = 10;
global VOETER_COUNT = 2;

fn check_within_budget(tokens_budget: u32, votes: [u32; CANDIDATE_COUNT]) {
    let mut tokens: u32 = 0;
    for i in 0..CANDIDATE_COUNT {
        let vote = votes[i];
        tokens = tokens + (vote * vote);
    }
    constrain tokens_budget >= tokens;
}

fn calculate_ballot_commitment(
    secret: Field,
    votes: [u32; CANDIDATE_COUNT]
) -> Field {
    let mut transcript = [0; CANDIDATE_COUNT + 1];
    transcript[0] = secret;
    for i in 0..CANDIDATE_COUNT {
        transcript[i + 1] = votes[i] as Field;
    };
    std::hash::pedersen(transcript)[0]
}

fn main(
    token_budget: pub u32,
    votes: [u32; CANDIDATE_COUNT],
    secret: Field
) -> pub Field {
    check_within_budget(token_budget, votes);
    calculate_ballot_commitment(secret, votes)
}