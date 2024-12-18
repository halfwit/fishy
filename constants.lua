--[[
Copyright © 2024, jimmy58663
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of HXIClam nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL jimmy58663 BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]] local data = {}

data.MoonPhasePercent = T {
    [1] = 100,
    [2] = 98,
    [3] = 95,
    [4] = 93,
    [5] = 90,
    [6] = 88,
    [7] = 86,
    [8] = 83,
    [9] = 81,
    [10] = 79,
    [11] = 76,
    [12] = 74,
    [13] = 71,
    [14] = 69,
    [15] = 67,
    [16] = 64,
    [17] = 62,
    [18] = 60,
    [19] = 57,
    [20] = 55,
    [21] = 52,
    [22] = 50,
    [23] = 48,
    [24] = 45,
    [25] = 43,
    [26] = 40,
    [27] = 38,
    [28] = 36,
    [29] = 33,
    [30] = 31,
    [31] = 29,
    [32] = 26,
    [33] = 24,
    [34] = 21,
    [35] = 19,
    [36] = 17,
    [37] = 14,
    [38] = 12,
    [39] = 10,
    [40] = 7,
    [41] = 5,
    [42] = 2,
    [43] = 0,
    [44] = 2,
    [45] = 5,
    [46] = 7,
    [47] = 10,
    [48] = 12,
    [49] = 14,
    [50] = 17,
    [51] = 19,
    [52] = 21,
    [53] = 24,
    [54] = 26,
    [55] = 29,
    [56] = 31,
    [57] = 33,
    [58] = 36,
    [59] = 38,
    [60] = 40,
    [61] = 43,
    [62] = 45,
    [63] = 48,
    [64] = 50,
    [65] = 52,
    [66] = 55,
    [67] = 57,
    [68] = 60,
    [69] = 62,
    [70] = 64,
    [71] = 67,
    [72] = 69,
    [73] = 71,
    [74] = 74,
    [75] = 76,
    [76] = 79,
    [77] = 81,
    [78] = 83,
    [79] = 86,
    [80] = 88,
    [81] = 90,
    [82] = 93,
    [83] = 95,
    [84] = 98
};

data.MoonPhase = T {
    [1] = 'Full Moon',
    [2] = 'Full Moon',
    [3] = 'Full Moon',
    [4] = 'Waning Gibbous',
    [5] = 'Waning Gibbous',
    [6] = 'Waning Gibbous',
    [7] = 'Waning Gibbous',
    [8] = 'Waning Gibbous',
    [9] = 'Waning Gibbous',
    [10] = 'Waning Gibbous',
    [11] = 'Waning Gibbous',
    [12] = 'Waning Gibbous',
    [13] = 'Waning Gibbous',
    [14] = 'Waning Gibbous',
    [15] = 'Waning Gibbous',
    [16] = 'Waning Gibbous',
    [17] = 'Waning Gibbous',
    [18] = 'Last Quarter',
    [19] = 'Last Quarter',
    [20] = 'Last Quarter',
    [21] = 'Last Quarter',
    [22] = 'Last Quarter',
    [23] = 'Last Quarter',
    [24] = 'Last Quarter',
    [25] = 'Last Quarter',
    [26] = 'Waning Crescent',
    [27] = 'Waning Crescent',
    [28] = 'Waning Crescent',
    [29] = 'Waning Crescent',
    [30] = 'Waning Crescent',
    [31] = 'Waning Crescent',
    [32] = 'Waning Crescent',
    [33] = 'Waning Crescent',
    [34] = 'Waning Crescent',
    [35] = 'Waning Crescent',
    [36] = 'Waning Crescent',
    [37] = 'Waning Crescent',
    [38] = 'Waning Crescent',
    [39] = 'New Moon',
    [40] = 'New Moon',
    [41] = 'New Moon',
    [42] = 'New Moon',
    [43] = 'New Moon',
    [44] = 'New Moon',
    [45] = 'New Moon',
    [46] = 'Waxing Crescent',
    [47] = 'Waxing Crescent',
    [48] = 'Waxing Crescent',
    [49] = 'Waxing Crescent',
    [50] = 'Waxing Crescent',
    [51] = 'Waxing Crescent',
    [52] = 'Waxing Crescent',
    [53] = 'Waxing Crescent',
    [54] = 'Waxing Crescent',
    [55] = 'Waxing Crescent',
    [56] = 'Waxing Crescent',
    [57] = 'Waxing Crescent',
    [58] = 'Waxing Crescent',
    [59] = 'First Quarter',
    [60] = 'First Quarter',
    [61] = 'First Quarter',
    [62] = 'First Quarter',
    [63] = 'First Quarter',
    [64] = 'First Quarter',
    [65] = 'First Quarter',
    [66] = 'First Quarter',
    [67] = 'Waxing Gibbous',
    [68] = 'Waxing Gibbous',
    [69] = 'Waxing Gibbous',
    [70] = 'Waxing Gibbous',
    [71] = 'Waxing Gibbous',
    [72] = 'Waxing Gibbous',
    [73] = 'Waxing Gibbous',
    [74] = 'Waxing Gibbous',
    [75] = 'Waxing Gibbous',
    [76] = 'Waxing Gibbous',
    [77] = 'Waxing Gibbous',
    [78] = 'Waxing Gibbous',
    [79] = 'Waxing Gibbous',
    [80] = 'Waxing Gibbous',
    [81] = 'Full Moon',
    [82] = 'Full Moon',
    [83] = 'Full Moon',
    [84] = 'Full Moon'
};

-- default list of fish
data.FishIndex = T {
        [90]   = "Rusty Bucket:50",
        [591]  = "Ripped Cap:0",
        [624]  = "Pantam Kelp:8",
        [1210] = "Damp Scroll:0",
        [4304] = "Grimmonite:717",
        [4314] = "Bibikibo:102",
        [4361] = "Nebimonite:53",
        [4384] = "Black Sole:717",
        [4385] = "Zafmlug Bass:31",
        [4426] = "Tricolored Carp:53",
        [4443] = "Cobalt Jellyfish:8",
        [4451] = "Silver Shark:512",
        [4461] = "Bastore Bream:615",
        [4463] = "Takitaro:731",
        [4471] = "Bladefish:408",
        [4475] = "Sea Zombie:715",
        [4479] = "Bhefhel Marlin:307",
        [4480] = "Gugru Tuna:102",
        [5128] = "Cone Calimary:169",
        [12316] = "Fish Scale Shield:399",
        [12522] = "Rusty Cap:98",
        [13454] = "Copper Ring:12",
        [13456] = "Silver Ring:256",
        [14117] = "Rusty Leggings:13",
        [14242] = "Rusty Subligar:16",
        [16451] = "Mithril Dagger:1431",
        [16655] = "Rusty Pick:115",
};

return data
