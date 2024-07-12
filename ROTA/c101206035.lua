--黎銘機ヘオスヴァローグ
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--Register an effect to be applied during the next Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.regcon)
	e1:SetTarget(s.regtg)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--Negate the activation of an opponent's Spell/Trap or effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Add from the GY 1 card to your hand with an effect that fusion summons during the next Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.thfilter(c)
	if not c:IsAbleToHand() then return end
	return c:IsCode(572850,1264319,1784686,3078380,3659803,5370235,6077601,6172122,6205579,6417578,6763530,7241272,7394770,7614732,8148322,8690387,9113513,10833828,11493868,11827244,12071500,12450071,13234975,13258285,15543940,17236839,17825378,21011044,23299957,24094653,24094654,24094655,24484270,25800447,25861589,26631975,26841274,27847700,29062925,29143457,29280589,29719112,30118701,31111109,31444249,31444250,31458630,31855260,31887806,32104431,33099732,33550694,34325937,34813443,34813545,34933456,34995106,35098357,35614780,35705817,36484016,37630732,37961969,38590361,39396763,39564736,40003819,40110009,40597694,41940225,42002073,42577802,42878636,43698897,44227727,44362883,44394295,44771289,45206713,45906428,46136942,47705572,48130397,48144509,49867899,50042011,51476410,51510279,51858200,52947044,52963531,53541822,54283059,54527349,55704856,57425061,58199906,58549532,58657303,59123937,59332125,59419719,59514116,60226558,60822251,62002838,62091148,62895219,63136489,63181559,64061284,65037172,65331686,65646587,65801012,65956182,66518509,67523044,67526112,68468459,68468460,70427670,70534340,71143015,71422989,71490127,71736213,71939275,72029628,72064891,72291412,72490637,73360025,73511233,73594093,74063034,74063035,74078255,74335036,76647978,76840111,77565204,78063197,78420796,79059098,80033124,81223446,81788994,82738008,84040113,86758746,86938484,87532344,87669904,87746184,87931906,88693151,88919365,89181134,91584698,92003832,93657021,94820406,95034141,95238394,95515789,95515790,98567237,98570539,98828338,99426088,99543666,99599062)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function s.rescon(sg,e,tp)
	return (#sg==1 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)) or sg:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,2,nil)) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=g:SelectSubGroup(tp,s.rescon,false,1,2,e,tp)
	Duel.Remove(cg,nil,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,tp,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
