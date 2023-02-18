--ホイール・シンクロン
function c101201201.initial_effect(c)
	--Can be treated as a non-Tuner for a Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--Normal Summon 1 Level 4 or lower monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201201,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101201201)
	e2:SetTarget(c101201201.nstg)
	e2:SetOperation(c101201201.nsop)
	c:RegisterEffect(e2)
	--Reduce the Level of 1 Synchro Monster you control by up to 4
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201201,1))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101201201+100)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c101201201.lvltg)
	e3:SetOperation(c101201201.lvlop)
	c:RegisterEffect(e3)
end
function c101201201.nsfilter(c)
	return c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end
function c101201201.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201201.nsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_MZONE)
end
function c101201201.nsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c39015.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if sc then
		Duel.Summon(tp,sc,true,nil)
	end
end
function c101201201.synchfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(2)
end
function c101201201.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101201201.synchfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101201201.synchfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
	Duel.SelectTarget(tp,c101201201.synchfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101201201.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local maxlv=math.min(5,lv)
		local t={}
		local l=1
		while l<maxlv do
			t[l]=l
			l=l+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101201201,2))
		local dlv=Duel.AnnounceNumber(tp,table.unpack(t))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-dlv)
		tc:RegisterEffect(e1)
	end
end

